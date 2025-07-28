// class UserModel {
//   final String id;
//   final String fullName;
//   final String email;
//   final String mobileNumber;
//   final String referralCode;
//   final String referredBy;
//   final bool isAgree;
//   final bool isEmailVerified;
//   final bool isMobileVerified;
//   final bool packageActive;
//   final bool isCommissionDistribute;
//   final List<String> serviceCustomers;
//   final List<String> favoriteServices;
//   final List<String> favoriteProviders;
//   final String createdAt;
//
//   UserModel({
//     required this.id,
//     required this.fullName,
//     required this.email,
//     required this.mobileNumber,
//     required this.referralCode,
//     required this.referredBy,
//     required this.isAgree,
//     required this.isEmailVerified,
//     required this.isMobileVerified,
//     required this.packageActive,
//     required this.isCommissionDistribute,
//     required this.serviceCustomers,
//     required this.favoriteServices,
//     required this.favoriteProviders,
//     required this.createdAt,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['_id'],
//       fullName: json['fullName'] ?? '',
//       email: json['email'] ?? '',
//       mobileNumber: json['mobileNumber'] ?? '',
//       referralCode: json['referralCode'] ?? '',
//       referredBy: json['referredBy'] ?? '',
//       isAgree: json['isAgree'] ?? false,
//       isEmailVerified: json['isEmailVerified'] ?? false,
//       isMobileVerified: json['isMobileVerified'] ?? false,
//       packageActive: json['packageActive'] ?? false,
//       isCommissionDistribute: json['isCommissionDistribute'] ?? false,
//       serviceCustomers: List<String>.from(json['serviceCustomers'] ?? []),
//       favoriteServices: List<String>.from(json['favoriteServices'] ?? []),
//       favoriteProviders: List<String>.from(json['favoriteProviders'] ?? []),
//       createdAt: json['createdAt'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "fullName": fullName,
//       "email": email,
//       "mobileNumber": mobileNumber,
//       "referralCode": referralCode,
//       "referredBy": referredBy,
//       "isAgree": isAgree,
//       "isEmailVerified": isEmailVerified,
//       "isMobileVerified": isMobileVerified,
//       "packageActive": packageActive,
//       "isCommissionDistribute": isCommissionDistribute,
//       "serviceCustomers": serviceCustomers,
//       "favoriteServices": favoriteServices,
//       "favoriteProviders": favoriteProviders,
//       "createdAt": createdAt,
//     };
//   }
//
// }


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
  final bool packageActive;
  final bool isCommissionDistribute;
  final List<String> serviceCustomers;
  final List<String> favoriteServices;
  final List<String> favoriteProviders;
  final bool isDeleted;
  final String createdAt;
  final String? updatedAt;
  final bool additionalDetailsCompleted;
  final bool addressCompleted;
  final bool personalDetailsCompleted;
  final List<String> myTeams;
  final String? packageType;
  final String? gender;
  final String? maritalStatus;
  final String? bloodGroup;
  final String? dateOfBirth;
  final String? education;
  final String? profession;
  final String? emergencyContact;

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
    required this.packageActive,
    required this.isCommissionDistribute,
    required this.serviceCustomers,
    required this.favoriteServices,
    required this.favoriteProviders,
    required this.isDeleted,
    required this.createdAt,
    this.updatedAt,
    required this.additionalDetailsCompleted,
    required this.addressCompleted,
    required this.personalDetailsCompleted,
    required this.myTeams,
    this.packageType,
    this.gender,
    this.maritalStatus,
    this.bloodGroup,
    this.dateOfBirth,
    this.education,
    this.profession,
    this.emergencyContact,
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
      packageActive: json['packageActive'] ?? false,
      isCommissionDistribute: json['isCommissionDistribute'] ?? false,
      serviceCustomers: List<String>.from(json['serviceCustomers'] ?? []),
      favoriteServices: List<String>.from(json['favoriteServices'] ?? []),
      favoriteProviders: List<String>.from(json['favoriteProviders'] ?? []),
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      additionalDetailsCompleted: json['additionalDetailsCompleted'] ?? false,
      addressCompleted: json['addressCompleted'] ?? false,
      personalDetailsCompleted: json['personalDetailsCompleted'] ?? false,
      myTeams: List<String>.from(json['myTeams'] ?? []),
      packageType: json['packageType'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      bloodGroup: json['bloodGroup'],
      dateOfBirth: json['dateOfBirth'],
      education: json['education'],
      profession: json['profession'],
      emergencyContact: json['emergencyContact'],
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
      "isDeleted": isDeleted,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "additionalDetailsCompleted": additionalDetailsCompleted,
      "addressCompleted": addressCompleted,
      "personalDetailsCompleted": personalDetailsCompleted,
      "myTeams": myTeams,
      "packageType": packageType,
      "gender": gender,
      "maritalStatus": maritalStatus,
      "bloodGroup": bloodGroup,
      "dateOfBirth": dateOfBirth,
      "education": education,
      "profession": profession,
      "emergencyContact": emergencyContact,
    };
  }
}
