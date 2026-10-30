import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveServices {
  Stream<QuerySnapshot> getActiveJobsStream() {
    return FirebaseFirestore.instance
        .collection('jobs')
        .where('status', isEqualTo: 'accepted')
        .snapshots();
  }

  Stream<DocumentSnapshot> getLiveBookingStream(String jobId) {
    return FirebaseFirestore.instance.collection('bookings').doc(jobId).snapshots();
  }
}