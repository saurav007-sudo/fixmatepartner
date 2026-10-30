import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/service and price ser.dart';

class ServicesPricingRepository {
  final ServicesPricingServices _services = ServicesPricingServices();

  Stream<DocumentSnapshot> getPartnerProfile(String uid) {
    return _services.getPartnerProfileStream(uid);
  }
}