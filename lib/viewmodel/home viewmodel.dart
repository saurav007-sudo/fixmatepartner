import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/home rep.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String get partnerId => currentUser?.uid ?? '';

  Future<void> updateJobStatus(String jobId, String status) async {
    await _repository.updateJobStatus(jobId, status, partnerId);
    notifyListeners();
  }

  Stream<DocumentSnapshot> getPartnerProfileStream() {
    return _repository.getPartnerProfile(partnerId);
  }

  Stream<QuerySnapshot> getEarningsStream() {
    return _repository.getEarnings(partnerId);
  }

  Stream<QuerySnapshot> getPendingJobsStream() {
    return _repository.getPendingJobs(partnerId);
  }

  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return _repository.getUserDetails(userId);
  }
}