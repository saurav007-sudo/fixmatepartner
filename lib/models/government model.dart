class GovernmentIdModel {
  final String idType;
  final String idNumber;
  final String idFrontUrl;
  final String idBackUrl;

  GovernmentIdModel({
    required this.idType,
    required this.idNumber,
    required this.idFrontUrl,
    required this.idBackUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'idType': idType,
      'idNumber': idNumber,
      'idFrontUrl': idFrontUrl,
      'idBackUrl': idBackUrl,
      'idSubmitted': true,
      'idStatus': 'Pending',
    };
  }
}