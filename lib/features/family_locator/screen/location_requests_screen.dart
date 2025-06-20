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