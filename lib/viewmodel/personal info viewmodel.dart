import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/personal info rep.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  final PersonalInfoRepository _repository = PersonalInfoRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<DocumentSnapshot> getPartnerProfileStream() {
    String uid = currentUser?.uid ?? 'sample_partner';
    return _repository.getPartnerProfile(uid);
  }
}