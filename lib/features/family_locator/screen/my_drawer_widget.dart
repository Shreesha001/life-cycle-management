import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/features/family_locator/screen/invlte_screen.dart'; 
import 'package:merge_app/features/family_locator/screen/location_requests_screen.dart';

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
            title: const Text("Find my family" , style: TextStyle(color: Colors.black),),
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