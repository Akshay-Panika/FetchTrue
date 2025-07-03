class LoginResponse {
  final String message;
  final String token;
  final UserModel user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String referralCode;
  final String? referredBy;
  final bool isAgree;
  final bool isEmailVerified;
  final bool isMobileVerified;
  final List<String> serviceCustomers;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.referralCode,
    this.referredBy,
    required this.isAgree,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.serviceCustomers,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      referralCode: json['referralCode'] ?? '',
      referredBy: json['referredBy'],
      isAgree: json['isAgree'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isMobileVerified: json['isMobileVerified'] ?? false,
      serviceCustomers: List<String>.from(json['serviceCustomers'] ?? []),
      createdAt: json['createdAt'] ?? '',
    );
  }
}
