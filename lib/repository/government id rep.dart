import 'package:image_picker/image_picker.dart';

import '../models/government model.dart';
import '../services/government id ser.dart';

class GovernmentIdRepository {
  final GovernmentIdServices _services = GovernmentIdServices();

  Future<String?> uploadImage(XFile imageFile) async {
    return await _services.uploadImageToSupabase(imageFile);
  }

  Future<void> submitId(String uid, GovernmentIdModel model) async {
    await _services.submitIdToFirestore(uid, model);
  }
}