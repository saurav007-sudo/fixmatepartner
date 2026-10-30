import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/addnew service model.dart';

class AddNewServices {
  Future<void> saveServiceToFirestore(String partnerId, AddNewModel addNewModel) async {
    await FirebaseFirestore.instance
        .collection('services')
        .add(addNewModel.toServiceMap(partnerId, FieldValue.serverTimestamp()));

    await FirebaseFirestore.instance
        .collection('partners')
        .doc(partnerId)
        .set(addNewModel.toPartnerMap(), SetOptions(merge: true));
  }
}