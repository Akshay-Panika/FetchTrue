class NonGpModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String referralCode;
  final bool packageActive;

  NonGpModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.referralCode,
    required this.packageActive,
  });

  factory NonGpModel.fromJson(Map<String, dynamic> json) {
    return NonGpModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      referralCode: json['referralCode'] ?? '',
      packageActive: json['packageActive'] ?? false,
    );
  }
}
