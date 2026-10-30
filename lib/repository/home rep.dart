import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/home ser.dart';

class HomeRepository {
  final HomeServices _services = HomeServices();

  Future<void> updateJobStatus(String jobId, String status, String partnerId) async {
    await _services.updateJobStatusInFirestore(jobId, status, partnerId);
  }

  Stream<DocumentSnapshot> getPartnerProfile(String partnerId) {
    return _services.getPartnerProfileStream(partnerId);
  }

  Stream<QuerySnapshot> getEarnings(String partnerId) {
    return _services.getEarningsStream(partnerId);
  }

  Stream<QuerySnapshot> getPendingJobs(String partnerId) {
    return _services.getPendingJobsStream(partnerId);
  }

  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return _services.getUserDocument(userId);
  }
}