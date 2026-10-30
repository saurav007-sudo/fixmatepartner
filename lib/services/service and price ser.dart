import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesPricingServices {
  Stream<DocumentSnapshot> getPartnerProfileStream(String uid) {
    return FirebaseFirestore.instance
        .collection('partners')
        .doc(uid)
        .snapshots();
  }
}