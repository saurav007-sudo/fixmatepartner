import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    await _repository.signOut(context);
    notifyListeners();
  }
}