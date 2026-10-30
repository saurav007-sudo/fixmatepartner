import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../repository/verify rep.dart';

class VerifyProfileViewModel extends ChangeNotifier {
  final VerifyProfileRepository _repository = VerifyProfileRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final List<String> titleList = [
    "Government ID",
    "Experience",
  ];

  final List<IconData> iconList = [
    CupertinoIcons.profile_circled,
    CupertinoIcons.doc_text,
  ];

  final List<Color> iconColorList = [
    Colors.blue,
    Colors.brown,
  ];

  final List<Color> bgColorList = [
    Color(0xFFE7F3FF),
    Color(0xFFFFF3E0),
  ];

  Stream<DocumentSnapshot> getPartnerProfileStream() {
    String uid = currentUser?.uid ?? 'sample_partner';
    return _repository.getPartnerProfile(uid);
  }

  Future<bool> submitForVerification() async {
    try {
      String uid = currentUser?.uid ?? 'sample_partner';
      await _repository.submitVerification(uid);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }
}