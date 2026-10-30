import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/editservice model.dart';

class EditServiceServices {
  final CollectionReference partnersRef = FirebaseFirestore.instance.collection('partners');

  Future<DocumentSnapshot> fetchPartnerDoc(String uid) async {
    return await partnersRef.doc(uid).get();
  }

  Future<void> updatePartnerService(String uid, EditServiceModel serviceModel) async {
    await partnersRef.doc(uid).set(serviceModel.toMap(), SetOptions(merge: true));
  }

  Future<void> updateCategoryService(String uid, String categoryName, EditServiceModel serviceModel) async {
    DocumentReference categoryDocRef = FirebaseFirestore.instance.collection(categoryName).doc(uid);
    var categoryDoc = await categoryDocRef.get();

    if (categoryDoc.exists) {
      await categoryDocRef.set(serviceModel.toMap(), SetOptions(merge: true));
    } else {
      var query = await FirebaseFirestore.instance
          .collection(categoryName)
          .where('uid', isEqualTo: uid)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.set(serviceModel.toMap(), SetOptions(merge: true));
      } else {
        await categoryDocRef.set({
          'uid': uid,
          ...serviceModel.toMap(),
        }, SetOptions(merge: true));
      }
    }
  }

  Future<void> deletePartnerService(String uid) async {
    Map<String, dynamic> deleteData = {
      'serviceName': FieldValue.delete(),
      'serviceDescription': FieldValue.delete(),
      'basePrice': FieldValue.delete(),
    };
    await partnersRef.doc(uid).set(deleteData, SetOptions(merge: true));
  }

  Future<void> deleteCategoryService(String uid, String categoryName) async {
    Map<String, dynamic> deleteData = {
      'serviceName': FieldValue.delete(),
      'serviceDescription': FieldValue.delete(),
      'basePrice': FieldValue.delete(),
    };
    await FirebaseFirestore.instance
        .collection(categoryName)
        .doc(uid)
        .set(deleteData, SetOptions(merge: true));
  }
}