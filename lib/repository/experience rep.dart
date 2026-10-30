

import '../models/experience model.dart';
import '../services/experience ser.dart';

class ExperienceRepository {
  final ExperienceServices _services = ExperienceServices();

  Future<void> saveExperience(String uid, ExperienceModel experienceModel) async {
    await _services.saveExperienceToFirestore(uid, experienceModel);
  }
}