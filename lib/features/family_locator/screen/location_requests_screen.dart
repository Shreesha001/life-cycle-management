import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/family_locator/screen/family_app_home_screen.dart';

class LocationRequestsScreen extends StatelessWidget {
  final String? familyId;

  const LocationRequestsScreen({super.key, this.familyId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Received Location Requests',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: user == null || familyId == null
          ? Center(
              child: Text(
                'No family or user data available.',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('location_requests')
                  .where('targetId', isEqualTo: user.uid)
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
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No location data found.',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final requesterId = request['requesterId'];
                    final status = request['status'];
                    final requestId = request.id;

                    return Dismissible(
                      key: Key(requestId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) async {
                        await FirebaseFirestore.instance
                            .collection('location_requests')
                            .doc(requestId)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Request deleted.',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(requesterId)
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
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
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
                                  fontSize: 16,
                                  color: primaryColor,
                                ),
                              ),
                              subtitle: Text(
                                'Status: $status',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              trailing: status == 'pending'
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () => _showDurationDialog(
                                              context, requestId, requesterId),
                                          child: Text(
                                            'Accept',
                                            style: GoogleFonts.poppins(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('location_requests')
                                                .doc(requestId)
                                                .update({'status': 'rejected'});
                                          },
                                          child: Text(
                                            'Reject',
                                            style: GoogleFonts.poppins(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Icon(
                                      status == 'accepted'
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: status == 'accepted'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                              onTap: status == 'accepted'
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FamilyAppHomeScreen(
                                            selectedMemberId: requesterId,
                                            familyId: familyId,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showDurationDialog(
      BuildContext context, String requestId, String requesterId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Share Location',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share your location with this user for how long?',
              style: GoogleFonts.poppins(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            DropdownButton<int>(
              isExpanded: true,
              value: 15,
              items: [15, 30, 60]
                  .map(
                    (minutes) => DropdownMenuItem(
                      value: minutes,
                      child: Text(
                        '$minutes minutes',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value != null) {
                  // Update request status to accepted
                  await FirebaseFirestore.instance
                      .collection('location_requests')
                      .doc(requestId)
                      .update({'status': 'accepted'});

                  // Start location sharing
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && familyId != null) {
                    final endTime = DateTime.now().add(Duration(minutes: value));
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                      'isSharing': true,
                      'sharingEndTime': endTime,
                      'familyId': familyId,
                    }, SetOptions(merge: true));

                    // Schedule stop sharing
                    Future.delayed(Duration(minutes: value), () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .set({
                        'isSharing': false,
                        'sharingEndTime': null,
                      }, SetOptions(merge: true));
                    });
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Location shared for $value minutes!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}