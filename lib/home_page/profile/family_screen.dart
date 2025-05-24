import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:merge_app/core/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/auth_screens/login_screen.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final TextEditingController _familyNameController = TextEditingController();
  String? familyId;

  @override
  void initState() {
    super.initState();
    _initDynamicLinks();
    _checkOrCreateFamily();
  }

  Future<void> _initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      await _handleDynamicLink(initialLink);
    }
    FirebaseDynamicLinks.instance.onLink
        .listen((dynamicLink) {
          _handleDynamicLink(dynamicLink);
        })
        .onError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Dynamic Link Error: $error')));
        });
  }

  Future<void> _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    if (deepLink.queryParameters.containsKey('familyId')) {
      final String familyId = deepLink.queryParameters['familyId']!;
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _addUserToFamily(user.uid, familyId);
        setState(() {
          this.familyId = familyId;
        });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  Future<void> _addUserToFamily(String userId, String familyId) async {
    try {
      final familyRef = FirebaseFirestore.instance
          .collection('families')
          .doc(familyId);
      await familyRef.update({
        'members': FieldValue.arrayUnion([userId]),
      });

      final user = FirebaseAuth.instance.currentUser;
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);
      final userDoc = await userRef.get();

      if (!userDoc.exists || !(userDoc.data()?.containsKey('name') ?? false)) {
        await userRef.set({
          'name': user?.email ?? 'User',
        }, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Joined family successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error joining family: $e')));
    }
  }

  Future<void> _checkOrCreateFamily() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    final query =
        await FirebaseFirestore.instance
            .collection('families')
            .where('members', arrayContains: user.uid)
            .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        familyId = query.docs.first.id;
      });
    }
  }

  Future<void> _createFamily(String familyName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    try {
      final familyRef = FirebaseFirestore.instance.collection('families').doc();
      await familyRef.set({
        'name': familyName,
        'members': [user.uid],
      });

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists || !(userDoc.data()?.containsKey('name') ?? false)) {
        await userRef.set({
          'name': user.email ?? 'User',
        }, SetOptions(merge: true));
      }

      setState(() {
        familyId = familyRef.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Family created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating family: $e')));
    }
  }

  Future<void> _shareInviteLink() async {
    if (familyId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No family selected')));
      return;
    }

    try {
      final parameters = DynamicLinkParameters(
        uriPrefix: 'https://lifecyclemanagement.page.link',
        link: Uri.parse(
          'https://lifecyclemanagement.page.link/invite?familyId=$familyId',
        ),
        androidParameters: AndroidParameters(
          packageName: 'com.example.merge_app',
        ),
        iosParameters: IOSParameters(
          bundleId: 'com.example.mergeApp',
          appStoreId: '123456789',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Join My Family!',
          description: 'You\'ve been invited to join a family on the app.',
        ),
      );

      final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance
          .buildShortLink(parameters);
      final String inviteLink = shortLink.shortUrl.toString();

      await Share.share('Join my family using this link: $inviteLink');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating link: $e')));
    }
  }

  Future<void> _removeMember(String memberId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || familyId == null) return;

    if (memberId == user.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot remove yourself from the family'),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Member'),
            content: const Text(
              'Are you sure you want to remove this member from the family?',
            ),
            actions: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: primaryColor)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: const Text('Remove'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        final familyRef = FirebaseFirestore.instance
            .collection('families')
            .doc(familyId);
        await familyRef.update({
          'members': FieldValue.arrayRemove([memberId]),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to remove member: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          'Family Management',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      floatingActionButton:
          familyId != null
              ? FloatingActionButton.extended(
                onPressed: _shareInviteLink,
                backgroundColor: secondaryColor,
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: Text(
                  'Invite Member',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
              : null,
      body:
          familyId == null
              ? _buildCreateFamilyForm()
              : _buildFamilyMembersList(),
    );
  }

  Widget _buildCreateFamilyForm() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create Your Family',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _familyNameController,
                decoration: InputDecoration(
                  labelText: 'Family Name',
                  labelStyle: TextStyle(color: secondaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryColor, width: 1.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter family name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_familyNameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a family name'),
                        ),
                      );
                      return;
                    }
                    _createFamily(_familyNameController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Family',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyMembersList() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('families')
              .doc(familyId)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                      future:
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(memberId)
                              .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const ListTile(
                            title: Text('Loading...'),
                            leading: CircleAvatar(child: Icon(Icons.person)),
                          );
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>?;
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
                            trailing:
                                memberId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? const Text(
                                      'You',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                    : IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () => _removeMember(memberId),
                                      tooltip: 'Remove member',
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
    );
  }
}
