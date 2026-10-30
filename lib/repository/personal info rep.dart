import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/personal info ser.dart';

class PersonalInfoRepository {
  final PersonalInfoServices _services = PersonalInfoServices();

  Stream<DocumentSnapshot> getPartnerProfile(String uid) {
    return _services.getPartnerProfileStream(uid);
  }
}