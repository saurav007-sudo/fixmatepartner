import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/active case ser.dart';

class ActiveRepository {
  final ActiveServices _services = ActiveServices();

  Stream<QuerySnapshot> getActiveJobs() {
    return _services.getActiveJobsStream();
  }

  Stream<DocumentSnapshot> getLiveBooking(String jobId) {
    return _services.getLiveBookingStream(jobId);
  }
}