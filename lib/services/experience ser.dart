import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/experience model.dart';

class ExperienceServices {
  final CollectionReference partnersRef = FirebaseFirestore.instance.collection('partners');

  Future<void> saveExperienceToFirestore(String uid, ExperienceModel experienceModel) async {
    await partnersRef.doc(uid).set(experienceModel.toMap(), SetOptions(merge: true));
  }
}