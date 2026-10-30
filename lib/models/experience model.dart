class ExperienceModel {
  final String experience;
  final String qualification;
  final String selectedCategory;
  final String description;

  ExperienceModel({
    required this.experience,
    required this.qualification,
    required this.selectedCategory,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'yearsOfExperience': experience,
      'qualification': qualification,
      'selectedCategory': selectedCategory,
      'workDescription': description,
      'experienceSubmitted': true,
      'isVerified': true,
    };
  }
}