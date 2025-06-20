import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart'; 
import 'package:merge_app/features/family_locator/screen/my_drawer_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class FamilyAppHomeScreen extends StatefulWidget {
  final String? selectedMemberId;
  final String? familyId;

  const FamilyAppHomeScreen({this.selectedMemberId, this.familyId, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FamilyAppHomeScreen> {
  GoogleMapController? mapController;
  LatLng _initialPosition = const LatLng(13.0827, 80.2707);
  Set<Marker> _markers = {};
  String? _familyId;
  bool _isLoading = true;
  bool _isSharing = false;
  int? _sharingDuration;
  DateTime? _sharingEndTime;
  BitmapDescriptor? _customMarker;
  StreamSubscription? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initialize();
    _setupCustomMarker();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _setupCustomMarker() async {
    _customMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/marker.png',
    );
  }

  Future<void> _initialize() async {
    try {
      setState(() => _isLoading = true);
      await _requestPermissions();
      await _fetchFamilyId();
      await _listenForLocationRequests();
      await _checkSharingStatus();
      await _fetchUserLocation();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Initialization error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPermissions() async {
    final permissions = await [
      Permission.location,
      Permission.locationAlways,
    ].request();

    if (permissions[Permission.location]?.isDenied ?? true  ) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are required')),
        );
      }
      return;
    }
  }

  Future<void> _fetchFamilyId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
      return;
    }

    try {
      final query = await FirebaseFirestore.instance
          .collection('families')
          .where('members', arrayContains: user.uid)
          .get();

      if (query.docs.isNotEmpty) {
        setState(() => _familyId = widget.familyId ?? query.docs.first.id);
        await _fetchFamilyMembersLocations();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No family found')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching family: $e')),
        );
      }
    }
  }

  Future<void> _startLocationSharing(int durationMinutes) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _familyId == null) return;

    try {
      final endTime = DateTime.now().add(Duration(minutes: durationMinutes));
      
      setState(() {
        _isSharing = true;
        _sharingDuration = durationMinutes;
        _sharingEndTime = endTime;
      });

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'isSharing': true,
        'sharingEndTime': endTime,
        'familyId': _familyId,
      }, SetOptions(merge: true));

      final service = FlutterBackgroundService();
      await service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          notificationChannelId: 'location_channel',
          foregroundServiceNotificationId: 888,
          initialNotificationTitle: 'Location Sharing Active',
          initialNotificationContent: 'Your location is being shared with family members',
        ),
        iosConfiguration: IosConfiguration(),
      );
      await service.startService();

      // Start location updates
      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((position) async {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'lastUpdated': FieldValue.serverTimestamp(),
          },
        }, SetOptions(merge: true));
      });

      // Schedule automatic stop
      Future.delayed(Duration(minutes: durationMinutes), () {
        if (mounted) _stopLocationSharing();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location sharing started for $durationMinutes minutes')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting sharing: $e')),
        );
      }
    }
  }

  Future<void> _stopLocationSharing() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _locationSubscription?.cancel();
      
      setState(() {
        _isSharing = false;
        _sharingDuration = null;
        _sharingEndTime = null;
      });

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'isSharing': false,
        'sharingEndTime': null,
      }, SetOptions(merge: true));

       FlutterBackgroundService().invoke('stopService');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location sharing stopped')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping sharing: $e')),
        );
      }
    }
  }

  Future<void> _checkSharingStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        final isSharing = data['isSharing'] as bool? ?? false;
        final endTime = data['sharingEndTime']?.toDate();

        if (isSharing && endTime != null && endTime.isAfter(DateTime.now())) {
          setState(() {
            _isSharing = true;
            _sharingEndTime = endTime;
            _sharingDuration = endTime.difference(DateTime.now()).inMinutes;
          });
          
          // Resume location updates if sharing is active
          _locationSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen((position) async {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'location': {
                'latitude': position.latitude,
                'longitude': position.longitude,
                'lastUpdated': FieldValue.serverTimestamp(),
              },
            }, SetOptions(merge: true));
          });
        } else if (isSharing) {
          await _stopLocationSharing();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking sharing status: $e')),
        );
      }
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && mounted) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'lastUpdated': FieldValue.serverTimestamp(),
          },
        }, SetOptions(merge: true));

        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching location: $e')),
        );
      }
    }
  }

  Future<void> _fetchFamilyMembersLocations() async {
    if (_familyId == null) return;

    try {
      final familyDoc = await FirebaseFirestore.instance
          .collection('families')
          .doc(_familyId!)
          .get();

      if (!familyDoc.exists) return;

      final members = List<String>.from(familyDoc.data()?['members'] ?? []);
      Set<Marker> newMarkers = {};

      for (String memberId in members) {
        if (memberId == FirebaseAuth.instance.currentUser?.uid) continue;

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final locationData = userData['location'] as Map<String, dynamic>?;
          final name = userData['name'] as String? ?? 'Unknown User';
          final isSharing = userData['isSharing'] as bool? ?? false;

          if (locationData != null && isSharing) {
            final lat = locationData['latitude'] as double?;
            final lng = locationData['longitude'] as double?;

            if (lat != null && lng != null) {
              final latLng = LatLng(lat, lng);
              final marker = Marker(
                markerId: MarkerId(memberId),
                position: latLng,
                infoWindow: InfoWindow(
                  title: name,
                  snippet: 'Last updated: ${DateTime.now().toString().split('.')[0]}',
                ),
                icon: _customMarker ?? BitmapDescriptor.defaultMarker,
                onTap: () {
                  mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(latLng, 14.0),
                  );
                  mapController?.showMarkerInfoWindow(MarkerId(memberId));
                },
              );
              newMarkers.add(marker);
            }
          }
        }
      }

      if (mounted) setState(() => _markers = newMarkers);
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
              
          final requesterName = requesterDoc['name'] as String? ?? 'Unknown User';

          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Location Request'),
                content: Text('$requesterName has requested your location. Share for how long?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('location_requests')
                          .doc(requestId)
                          .update({'status': 'rejected'});
                      if (mounted) Navigator.pop(context);
                    },
                    child: Text('Reject', style: TextStyle(color: primaryColor)),
                  ),
                  DropdownButton<int>(
                    value: 15,
                    items: [15, 30, 60].map((minutes) => DropdownMenuItem(
                      value: minutes,
                      child: Text('$minutes minutes'),
                    )).toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        await _startLocationSharing(value);
                        await FirebaseFirestore.instance
                            .collection('location_requests')
                            .doc(requestId)
                            .update({'status': 'accepted'});
                        if (mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error handling request: $e')),
            );
          }
        }
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() => mapController = controller);
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
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      if (_isSharing)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Sharing until ${_sharingEndTime?.toString().split('.')[0]}',
                              style: GoogleFonts.poppins(color: Colors.green),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _isSharing
                            ? _stopLocationSharing
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Share Location'),
                                    content: const Text('Select sharing duration'),
                                    actions: [
                                      DropdownButton<int>(
                                        value: 15,
                                        items: [15, 30, 60].map((minutes) => DropdownMenuItem(
                                          value: minutes,
                                          child: Text('$minutes minutes'),
                                        )).toList(),
                                        onChanged: (value) async {
                                          if (value != null) {
                                            await _startLocationSharing(value);
                                            if (mounted) Navigator.pop(context);
                                          }
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel', style: TextStyle(color: primaryColor)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSharing ? Colors.red : Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          _isSharing ? 'Stop Sharing' : 'Start Sharing Location',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    service.stopSelf();
    return;
  }

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  ).listen((position) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Sharing Location',
        content: 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
      );
    }
  });
}