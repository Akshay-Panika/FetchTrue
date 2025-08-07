class ReferredUser {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String referralCode;

  ReferredUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.referralCode,
  });

  factory ReferredUser.fromJson(Map<String, dynamic> json) {
    return ReferredUser(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      referralCode: json['referralCode'],
    );
  }
}
