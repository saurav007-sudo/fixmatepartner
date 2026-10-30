import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/verify ser.dart';

class VerifyProfileRepository {
  final VerifyProfileServices _services = VerifyProfileServices();

  Stream<DocumentSnapshot> getPartnerProfile(String uid) {
    return _services.getPartnerProfileStream(uid);
  }

  Future<void> submitVerification(String uid) async {
    await _services.submitVerificationInFirestore(uid);
  }
}