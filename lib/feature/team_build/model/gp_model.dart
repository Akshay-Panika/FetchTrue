class GpModel {
  final String fullName;
  final String email;
  final String mobileNumber;
  final String referralCode;
  final bool packageActive;

  GpModel({
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.referralCode,
    required this.packageActive,
  });

  factory GpModel.fromJson(Map<String, dynamic> json) {
    return GpModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      referralCode: json['referralCode'] ?? '',
      packageActive: json['packageActive'] == true, // 👈 handles null as false
    );
  }
}
