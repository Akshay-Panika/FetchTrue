class ReferralUserModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String referralCode;

  ReferralUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.referralCode,
  });

  factory ReferralUserModel.fromJson(Map<String, dynamic> json) {
    return ReferralUserModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      referralCode: json['referralCode'],
    );
  }
}
