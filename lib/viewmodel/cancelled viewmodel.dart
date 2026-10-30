import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/cancelled rep.dart';

class CancelledJobsViewModel extends ChangeNotifier {
  final CancelledJobsRepository _repository = CancelledJobsRepository();

  Stream<QuerySnapshot> getCancelledJobsStream() {
    return _repository.getCancelledJobs();
  }
}