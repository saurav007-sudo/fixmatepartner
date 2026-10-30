import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/service and price rep.dart';

class ServicesPricingViewModel extends ChangeNotifier {
  final ServicesPricingRepository _repository = ServicesPricingRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<DocumentSnapshot> getPartnerProfileStream() {
    String uid = currentUser?.uid ?? 'sample_partner';
    return _repository.getPartnerProfile(uid);
  }
}