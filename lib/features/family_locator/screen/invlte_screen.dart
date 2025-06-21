import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/family_locator/screen/family_app_home_screen.dart';

class InviteScreen extends StatefulWidget {
  final String? familyId;

  const InviteScreen({super.key, this.familyId});

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  String? familyId;
  bool _isLoading = true;
  Map<String, bool> _sharingStatus = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      setState(() => _isLoading = true);
      if (widget.familyId != null) {
        setState(() => familyId = widget.familyId);
      } else {
        await _checkOrCreateFamily();
      }
      if (familyId != null) {
        await _listenForSharingStatus();
      }
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

  Future<void> _checkOrCreateFamily() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/signin');
      }
      return;
    }

    final query = await FirebaseFirestore.instance
        .collection('families')
        .where('members', arrayContains: user.uid)
        .get();

    if (query.docs.isNotEmpty && mounted) {
      setState(() => familyId = query.docs.first.id);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No family found.')),
        );
      }
    }
  }

  Future<void> _listenForSharingStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || familyId == null) return;

    FirebaseFirestore.instance
        .collection('families')
        .doc(familyId)
        .snapshots()
        .listen((familySnapshot) async {
      if (!familySnapshot.exists) return;

      final familyData = familySnapshot.data() as Map<String, dynamic>;
      final List<dynamic> members = familyData['members'] ?? [];

      for (String memberId in members) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .snapshots()
            .listen((userSnapshot) {
          if (!userSnapshot.exists) return;

          final userData = userSnapshot.data() as Map<String, dynamic>?;
          final isSharing = userData?['isSharing'] ?? false;
          final sharingEndTime = userData?['sharingEndTime']?.toDate();

          bool isCurrentlySharing = isSharing &&
              sharingEndTime != null &&
              sharingEndTime.isAfter(DateTime.now());

          if (isCurrentlySharing != (_sharingStatus[memberId] ?? false)) {
            if (mounted) {
              setState(() {
                _sharingStatus[memberId] = isCurrentlySharing;
              });
            }
          }

          // Schedule cleanup if sharing has ended
          if (!isCurrentlySharing && isSharing) {
            FirebaseFirestore.instance.collection('users').doc(memberId).set({
              'isSharing': false,
              'sharingEndTime': null,
            }, SetOptions(merge: true));
          }
        });
      }
    });
  }

  Future<void> _requestMemberLocation(String targetId, String targetName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || familyId == null) return;

    try {
      await FirebaseFirestore.instance.collection('location_requests').doc().set({
        'familyId': familyId,
        'requesterId': user.uid,
        'targetId': targetId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location request sent to $targetName')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send location request: $e')),
        );
      }
    }
  }

  void _showRequestConfirmationDialog(String targetId, String targetName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Request Location',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        content: Text(
          'Do you want to request $targetName\'s location?',
          style: GoogleFonts.poppins(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _requestMemberLocation(targetId, targetName);
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || _isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Family Members"),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: familyId == null
          ? Center(
              child: Text(
                'No family selected.',
                style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('families')
                  .doc(familyId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Text(
                      'No family data found.',
                      style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
                    ),
                  );
                }

                final familyData = snapshot.data!.data() as Map<String, dynamic>;
                final List<dynamic> members = familyData['members'] ?? [];
                final String familyName = familyData['name'] ?? 'Your Family';

                if (members.isEmpty) {
                  return Center(
                    child: Text(
                      'No members in the family yet.',
                      style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        familyName,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          itemCount: members.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final memberId = members[index];
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(memberId)
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
                                final isSharing = _sharingStatus[memberId] ?? false;

                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      _showRequestConfirmationDialog(memberId, name);
                                    },
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
                                      isSharing ? 'Sharing Location' : 'Not Sharing',
                                      style: GoogleFonts.poppins(
                                        color: isSharing ? Colors.green : Colors.grey[600],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.location_on, color: primaryColor),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FamilyAppHomeScreen(
                                              selectedMemberId: memberId,
                                              familyId: familyId,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}