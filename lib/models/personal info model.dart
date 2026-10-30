class PersonalInfoModel {
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String category;
  final String? profileImageUrl;

  PersonalInfoModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.category,
    this.profileImageUrl,
  });

  factory PersonalInfoModel.fromMap(Map<String, dynamic>? map) {
    return PersonalInfoModel(
      name: map?['name'] ?? "Suresh Babu",
      email: map?['email'] ?? "ksaurath@gmail.com",
      phone: map?['phone'] ?? "+91 6282716279",
      dob: map?['dob'] ?? "08/12/2003",
      category: map?['selectedCategory'] ?? map?['category'] ?? "Electrician",
      profileImageUrl: map?['profileImage'],
    );
  }
}