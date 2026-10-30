import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/editservice model.dart';
import '../services/editservice ser.dart';

class EditServiceRepository {
  final EditServiceServices _services = EditServiceServices();

  Future<EditServiceModel?> getServiceData(String uid) async {
    DocumentSnapshot doc = await _services.fetchPartnerDoc(uid);
    if (doc.exists) {
      return EditServiceModel.fromMap(doc.data() as Map<String, dynamic>?);
    }
    return null;
  }

  Future<void> updateService(String uid, EditServiceModel serviceModel) async {
    await _services.updatePartnerService(uid, serviceModel);

    if (serviceModel.category != null && serviceModel.category!.trim().isNotEmpty) {
      await _services.updateCategoryService(uid, serviceModel.category!.trim(), serviceModel);
    }
  }

  Future<void> deleteService(String uid, String? category) async {
    await _services.deletePartnerService(uid);

    if (category != null && category.trim().isNotEmpty) {
      await _services.deleteCategoryService(uid, category.trim());
    }
  }
}