import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:merge_app/features/family_locator/screen/invlte_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:merge_app/core/colors.dart';
import 'package:google_fonts/google_fonts.dart'; 

class FamilyAppHomeScreen extends StatefulWidget {
  final String? selectedMemberId;
  final String? familyId;

  const FamilyAppHomeScreen({this.selectedMemberId, this.familyId, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FamilyAppHomeScreen> {
  GoogleMapController? mapController;
  LatLng _initialPosition = const LatLng(13.0827, 80.2707); // Default (Chennai)
  final Location _location = Location();
  Set<Marker> _markers = {};
  String? _familyId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Future.wait([
        _fetchUserLocation(),
        _fetchFamilyId(),
      ]);
      await _listenForLocationRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Initialization error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchFamilyId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated.')),
        );
      }
      return;
    }

    try {
      final query = await FirebaseFirestore.instance
          .collection('families')
          .where('members', arrayContains: user.uid)
          .get();

      if (query.docs.isNotEmpty && mounted) {
        setState(() {
          _familyId = widget.familyId ?? query.docs.first.id;
        });
        await _fetchFamilyMembersLocations();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No family found.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching family: $e')),
        );
      }
    }
  }

  Future<void> _fetchUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        final locData = await _location.getLocation();
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && locData.latitude != null && locData.longitude != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'location': {
              'latitude': locData.latitude,
              'longitude': locData.longitude,
              'lastUpdated': FieldValue.serverTimestamp(),
            },
          }, SetOptions(merge: true));

          if (mounted) {
            setState(() {
              _initialPosition = LatLng(locData.latitude!, locData.longitude!);
            });
          }

          _location.onLocationChanged.listen((locData) async {
            if (locData.latitude != null && locData.longitude != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                'location': {
                  'latitude': locData.latitude,
                  'longitude': locData.longitude,
                  'lastUpdated': FieldValue.serverTimestamp(),
                },
              }, SetOptions(merge: true));
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error fetching location: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required.')),
        );
      }
    }
  }

  Future<void> _fetchFamilyMembersLocations() async {
    if (_familyId == null) return;

    try {
      final familyDoc = await FirebaseFirestore.instance
          .collection('families')
          .doc(_familyId)
          .get();

      if (!familyDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Family data not found.')),
          );
        }
        return;
      }

      final members = List<String>.from(familyDoc['members'] ?? []);
      Set<Marker> newMarkers = {};

      for (String memberId in members) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .get();

        if (userDoc.exists && userDoc.data()!.containsKey('location')) {
          final locationData = userDoc['location'];
          final name = userDoc['name'] ?? 'Unknown User';
          final lat = locationData['latitude']?.toDouble();
          final lng = locationData['longitude']?.toDouble();

          if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
            final latLng = LatLng(lat, lng);
            final marker = Marker(
              markerId: MarkerId(memberId),
              position: latLng,
              infoWindow: InfoWindow(
                title: name,
                snippet: 'Last updated: ${DateTime.now().toString().split('.')[0]}',
              ),
              icon: memberId == widget.selectedMemberId
                  ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                  : BitmapDescriptor.defaultMarker,
              onTap: () {
                mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(latLng, 14.0),
                );
                mapController?.showMarkerInfoWindow(MarkerId(memberId));
              },
            );
            newMarkers.add(marker);

            // Automatically show InfoWindow for selected member
            if (memberId == widget.selectedMemberId && mounted) {
              mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(latLng, 14.0),
              );
              await Future.delayed(const Duration(milliseconds: 500));
              mapController?.showMarkerInfoWindow(MarkerId(memberId));
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          _markers = newMarkers;
        });
      }

      if (newMarkers.isEmpty && widget.selectedMemberId != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No location available for this member.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching locations: $e')),
        );
      }
    }
  }

  Future<void> _listenForLocationRequests() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _familyId == null) return;

    try {
      FirebaseFirestore.instance
          .collection('location_requests')
          .where('targetId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snapshot) async {
        for (var doc in snapshot.docs) {
          final requesterId = doc['requesterId'];
          final requestId = doc.id;

          try {
            final requesterDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(requesterId)
                .get();
            final requesterName = requesterDoc['name'] ?? 'Unknown User';

            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Location Request'),
                  content: Text(
                      '$requesterName has requested your location. Share your location?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('location_requests')
                            .doc(requestId)
                            .update({'status': 'rejected'});
                        Navigator.pop(context);
                      },
                      child: Text('Reject', style: TextStyle(color: primaryColor)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final locData = await _location.getLocation();
                          if (locData.latitude != null &&
                              locData.longitude != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({
                              'location': {
                                'latitude': locData.latitude,
                                'longitude': locData.longitude,
                                'lastUpdated': FieldValue.serverTimestamp(),
                              },
                            }, SetOptions(merge: true));

                            await FirebaseFirestore.instance
                                .collection('location_requests')
                                .doc(requestId)
                                .update({'status': 'accepted'});

                            Navigator.pop(context);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Location shared!')),
                              );
                              await _fetchFamilyMembersLocations();
                            }
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error sharing location')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text('Accept'),
                    ),
                  ],
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error processing request: $e')),
              );
            }
          }
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error listening for requests: $e')),
        );
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        mapController = controller;
      });
      _fetchFamilyMembersLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find my family'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: primaryColor),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: MyDrawerWidget(familyId: _familyId),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
            ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}

class MyDrawerWidget extends StatelessWidget {
  final String? familyId;

  const MyDrawerWidget({super.key, this.familyId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(child: Text("S")),
            accountName: Text(
              "Shreesha",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            accountEmail: null,
          ),
          ListTile(
            title: const Text("Find my family"),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Share location with my family"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InviteScreen(familyId: familyId),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Location Requests"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationRequestsScreen(familyId: familyId),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Version 1.0.7\nSimple Design",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationRequestsScreen extends StatelessWidget {
  final String? familyId;

  const LocationRequestsScreen({super.key, this.familyId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sent Location Requests'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: user == null || familyId == null
          ? const Center(child: Text('No family or user data available.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('location_requests')
                  .where('requesterId', isEqualTo: user.uid)
                  .where('familyId', isEqualTo: familyId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(
                          color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No location requests sent.',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[600], fontSize: 16),
                    ),
                  );
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final targetId = request['targetId'];
                    final status = request['status'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(targetId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Loading...'),
                            leading: CircleAvatar(child: Icon(Icons.person)),
                          );
                        }

                        if (userSnapshot.hasError) {
                          return const ListTile(
                            title: Text('Error loading user'),
                            leading: CircleAvatar(child: Icon(Icons.error)),
                          );
                        }

                        final userData =
                            userSnapshot.data?.data() as Map<String, dynamic>?;
                        final name = userData?['name'] ?? 'Unknown User';

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: secondaryColor,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: primaryColor,
                              ),
                            ),
                            subtitle: Text(
                              'Status: $status',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: Icon(
                              status == 'pending'
                                  ? Icons.hourglass_empty
                                  : status == 'accepted'
                                      ? Icons.check_circle
                                      : Icons.cancel,
                              color: status == 'pending'
                                  ? Colors.orange
                                  : status == 'accepted'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                            onTap: status == 'accepted'
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FamilyAppHomeScreen(
                                          selectedMemberId: targetId,
                                          familyId: familyId,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}