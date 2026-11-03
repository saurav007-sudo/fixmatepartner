import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmatepartner/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../repository/profile rep.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final List<IconData> profileIcons = [
    CupertinoIcons.person,
    CupertinoIcons.doc_text,
    CupertinoIcons.lock_shield,
  ];

  final List<String> profileTitles = [
    "Personal Information",
    "Services & Pricing      ",
    "Privacy & Security      ",
  ];

  Stream<DocumentSnapshot> getPartnerProfileStream() {
    String uid = currentUser?.uid ?? 'sample_partner';
    return _repository.getPartnerProfile(uid);
  }

 Future<void> signOut(BuildContext context) async {
    try {
      // Optional: Show confirmation dialog before logging out
      bool? confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await FirebaseAuth.instance.signOut();

        if (!context.mounted) return;

        // Navigate to your Login Page and remove all previous routes from stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()), // Replace with your actual login screen widget name
              (route) => false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }
}