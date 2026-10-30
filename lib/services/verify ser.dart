import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyProfileServices {
  Stream<DocumentSnapshot> getPartnerProfileStream(String uid) {
    return FirebaseFirestore.instance
        .collection('partners')
        .doc(uid)
        .snapshots();
  }

  Future<void> submitVerificationInFirestore(String uid) async {
    await FirebaseFirestore.instance.collection('partners').doc(uid).set({
      'verificationStatus': 'Pending',
      'isVerified': false,
      'idSubmitted': true,
    }, SetOptions(merge: true));
  }
}