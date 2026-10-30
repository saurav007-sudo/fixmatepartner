import 'package:cloud_firestore/cloud_firestore.dart';

class HomeServices {
  Future<void> updateJobStatusInFirestore(String jobId, String status, String partnerId) async {
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({
      'status': status,
      'partnerId': partnerId,
    });
  }

  Stream<DocumentSnapshot> getPartnerProfileStream(String partnerId) {
    return FirebaseFirestore.instance
        .collection('partners')
        .doc(partnerId)
        .snapshots();
  }

  Stream<QuerySnapshot> getEarningsStream(String partnerId) {
    return FirebaseFirestore.instance
        .collection('jobs')
        .where('partnerId', isEqualTo: partnerId)
        .where('status', whereIn: ['completed', 'closed'])
        .snapshots();
  }

  Stream<QuerySnapshot> getPendingJobsStream(String partnerId) {
    return FirebaseFirestore.instance
        .collection('jobs')
        .where('status', isEqualTo: 'pending')
        .where('partnerId', isEqualTo: partnerId)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserDocument(String userId) async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }
}