import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot> getPartnerProfileStream(String uid) {
    return FirebaseFirestore.instance
        .collection('partners')
        .doc(uid)
        .snapshots();
  }

  Future<void> signOutUser(BuildContext context) async {
    await _auth.signOut();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged out successfully")),
    );
  }
}