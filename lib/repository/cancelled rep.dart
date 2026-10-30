import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/cancelled ser.dart';

class CancelledJobsRepository {
  final CancelledJobsServices _services = CancelledJobsServices();

  Stream<QuerySnapshot> getCancelledJobs() {
    return _services.getCancelledJobsStream();
  }
}