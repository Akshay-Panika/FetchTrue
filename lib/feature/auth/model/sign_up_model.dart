class SignUpModel {
  final String fullName;
  final String email;
  final String mobileNumber;
  final String password;
  final String referredBy;
  final bool isAgree;

  SignUpModel({
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.referredBy,
    required this.isAgree,
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "mobileNumber": mobileNumber,
    "password": password,
    "referredBy": referredBy,
    "isAgree": isAgree,
  };
}