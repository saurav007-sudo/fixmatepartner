import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/active  rep.dart';

class ActiveViewModel extends ChangeNotifier {
  final ActiveRepository _repository = ActiveRepository();

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  Stream<QuerySnapshot> getActiveJobsStream() {
    return _repository.getActiveJobs();
  }

  Stream<DocumentSnapshot> getLiveBookingStream(String jobId) {
    return _repository.getLiveBooking(jobId);
  }
}