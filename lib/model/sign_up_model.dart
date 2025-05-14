class UserRegistrationModel {
  final String fullName;
  final String email;
  final String mobileNumber;
  final String password;
  final String confirmPassword;
  final String? referredBy;
  final bool? isAgree;

  UserRegistrationModel({
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.confirmPassword,
    this.referredBy,
    this.isAgree,
  });

  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) {
    return UserRegistrationModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      referredBy: json['referredBy'] ?? '',
      isAgree: json['isAgree'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'mobileNumber': mobileNumber,
      'password': password,
      'confirmPassword': confirmPassword,
      'referredBy': referredBy,
      'isAgree': isAgree,
    };
  }
}
