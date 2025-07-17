class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String referralCode;
  final String referredBy;
  final bool isAgree;
  final bool isEmailVerified;
  final bool isMobileVerified;
  final bool packageActive;
  final bool isCommissionDistribute;
  final List<String> serviceCustomers;
  final List<String> favoriteServices;
  final List<String> favoriteProviders;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.referralCode,
    required this.referredBy,
    required this.isAgree,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.packageActive,
    required this.isCommissionDistribute,
    required this.serviceCustomers,
    required this.favoriteServices,
    required this.favoriteProviders,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      referralCode: json['referralCode'] ?? '',
      referredBy: json['referredBy'] ?? '',
      isAgree: json['isAgree'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isMobileVerified: json['isMobileVerified'] ?? false,
      packageActive: json['packageActive'] ?? false,
      isCommissionDistribute: json['isCommissionDistribute'] ?? false,
      serviceCustomers: List<String>.from(json['serviceCustomers'] ?? []),
      favoriteServices: List<String>.from(json['favoriteServices'] ?? []),
      favoriteProviders: List<String>.from(json['favoriteProviders'] ?? []),
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullName": fullName,
      "email": email,
      "mobileNumber": mobileNumber,
      "referralCode": referralCode,
      "referredBy": referredBy,
      "isAgree": isAgree,
      "isEmailVerified": isEmailVerified,
      "isMobileVerified": isMobileVerified,
      "packageActive": packageActive,
      "isCommissionDistribute": isCommissionDistribute,
      "serviceCustomers": serviceCustomers,
      "favoriteServices": favoriteServices,
      "favoriteProviders": favoriteProviders,
      "createdAt": createdAt,
    };
  }

}
