class VerifyProfileModel {
  final bool idVerified;
  final bool expVerified;

  VerifyProfileModel({
    required this.idVerified,
    required this.expVerified,
  });

  factory VerifyProfileModel.fromMap(Map<String, dynamic>? map) {
    return VerifyProfileModel(
      idVerified: map?['idSubmitted'] ?? false,
      expVerified: map?['experienceSubmitted'] ?? false,
    );
  }
}