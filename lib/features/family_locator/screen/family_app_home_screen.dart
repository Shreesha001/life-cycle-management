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

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<BitmapDescriptor> getResizedMarkerIcon(String assetPath, int width) async {
  final ByteData data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  final frame = await codec.getNextFrame();
  final image = frame.image;
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

class FamilyAppHomeScreen extends StatefulWidget {
  final String? selectedMemberId;
  final String? familyId;

  const FamilyAppHomeScreen({this.selectedMemberId, this.familyId, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FamilyAppHomeScreen> {
  GoogleMapController? mapController;
  LatLng _initialPosition = const LatLng(13.0827, 80.2707); // Default fallback position
  Set<Marker> _markers = {};
  String? _familyId;
  bool _isLoading = true;
  bool _isSharing = false;
  int? _sharingDuration;
  DateTime? _sharingEndTime;
  BitmapDescriptor? _customMarker;

  @override
  void initState() {
    super.initState();
    _initialize();
    _setupCustomMarker();
  }

  Future<void> _setupCustomMarker() async {
    _customMarker = await getResizedMarkerIcon('assets/marker.png', 48); // 48 pixels wide
    if (mounted) setState(() {});
  }

  Future<void> _initialize() async {
    try {
      setState(() => _isLoading = true);
      await Future.wait([
        _requestPermissions(),
        _fetchFamilyId(),
        _getCurrentLocation(),
      ]);
      await _listenForLocationRequests();
      await _checkSharingStatus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Initialization error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);
        });
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_initialPosition, 14.0),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  Future<void> _requestPermissions() async {
    final permissions = [Permission.location, Permission.locationAlways];
    for (var permission in permissions) {
      var status = await permission.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required.')),
          );
        }
        return;
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

    final query = await FirebaseFirestore.instance
        .collection('families')
        .where('members', arrayContains: user.uid)
        .get();

    if (query.docs.isNotEmpty && mounted) {
      setState(() => _familyId = widget.familyId ?? query.docs.first.id);
      await _fetchFamilyMembersLocations();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No family found.')));
      }
    }
  }

  Future<void> _fetchFamilyMembersLocations() async {
    if (_familyId == null) return;

    final familyDoc = await FirebaseFirestore.instance.collection('families').doc(_familyId).get();

    if (!familyDoc.exists) return;

    final members = List<String>.from(familyDoc['members'] ?? []);
    Set<Marker> newMarkers = {};

    for (String memberId in members) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(memberId).get();
      final data = userDoc.data();
      if (userDoc.exists && data != null && data.containsKey('location') && data.containsKey('isSharing')) {
        final locationData = data['location'];
        final isSharing = data['isSharing'] ?? false;
        final name = data['name'] ?? 'Unknown User';
        final lastUpdated = (locationData['lastUpdated'] as Timestamp?)?.toDate().toString().split('.')[0] ?? 'Unknown';

        final lat = locationData['latitude']?.toDouble();
        final lng = locationData['longitude']?.toDouble();

        if (lat != null && lng != null && isSharing == true) {
          final latLng = LatLng(lat, lng);
          final marker = Marker(
            markerId: MarkerId(memberId),
            position: latLng,
            infoWindow: InfoWindow(
              title: name,
              snippet: 'Last updated: $lastUpdated',
            ),
            icon: _customMarker ?? BitmapDescriptor.defaultMarker,
            onTap: () {
              mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14.0));
              mapController?.showMarkerInfoWindow(MarkerId(memberId));
            },
          );
          newMarkers.add(marker);
        }
      }
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
        _showAllInfoWindows(); // Show all InfoWindows after updating markers
      });
    }
  }

  void _showAllInfoWindows() {
    // Show InfoWindow for all markers
    for (var marker in _markers) {
      mapController?.showMarkerInfoWindow(marker.markerId);
    }
  }

  Future<void> _startLocationSharing(int durationMinutes) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _familyId == null) return;

    setState(() {
      _isSharing = true;
      _sharingDuration = durationMinutes;
      _sharingEndTime = DateTime.now().add(Duration(minutes: durationMinutes));
    });

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'isSharing': true,
      'sharingEndTime': _sharingEndTime,
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

    Future.delayed(Duration(minutes: durationMinutes), () {
      if (mounted) _stopLocationSharing();
    });
  }

  Future<void> _stopLocationSharing() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

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
  }

  Future<void> _checkSharingStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = userDoc.data();
    if (data == null) return;

    final isSharing = data['isSharing'] ?? false;
    final endTime = data['sharingEndTime']?.toDate();

    if (isSharing && endTime != null && endTime.isAfter(DateTime.now())) {
      setState(() {
        _isSharing = true;
        _sharingEndTime = endTime;
        _sharingDuration = endTime.difference(DateTime.now()).inMinutes;
      });
    } else if (isSharing) {
      await _stopLocationSharing();
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

        final requesterDoc = await FirebaseFirestore.instance.collection('users').doc(requesterId).get();
        final requesterName = requesterDoc['name'] ?? 'Unknown User';

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Location Request', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              content: Text('$requesterName has requested your location. Share for how long?', style: GoogleFonts.poppins()),
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
                DropdownButton<int>(
                  value: 15,
                  items: [15, 30, 60].map((minutes) => DropdownMenuItem(value: minutes, child: Text('$minutes minutes'))).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      await _startLocationSharing(value);
                      await FirebaseFirestore.instance
                          .collection('location_requests')
                          .doc(requestId)
                          .update({'status': 'accepted'});
                      Navigator.pop(context);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location shared for $value minutes!')));
                      }
                    }
                  },
                ),
              ],
            ),
          );
        }
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() => mapController = controller);
      _fetchFamilyMembersLocations();
      _getCurrentLocation(); // Ensure map centers on user location
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find my family', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
                  initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14.0),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      if (_isSharing)
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Sharing until ${_sharingEndTime?.toString().split('.')[0]}',
                              style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.w500),
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
                                    title: Text('Share Location', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                    content: Text('Select sharing duration', style: GoogleFonts.poppins()),
                                    actions: [
                                      DropdownButton<int>(
                                        value: 15,
                                        items: [15, 30, 60].map((minutes) => DropdownMenuItem(value: minutes, child: Text('$minutes minutes'))).toList(),
                                        onChanged: (value) async {
                                          if (value != null) {
                                            await _startLocationSharing(value);
                                            Navigator.pop(context);
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          _isSharing ? 'Stop Sharing' : 'Start Sharing Location',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
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

  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      timeLimit: Duration(seconds: 5),
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

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}