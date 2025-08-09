// my_team_model.dart
import 'dart:convert';

MyTeamModel myTeamModelFromJson(String str) => MyTeamModel.fromJson(json.decode(str));
String myTeamModelToJson(MyTeamModel data) => json.encode(data.toJson());

class MyTeamModel {
  final bool success;
  final List<TeamData> team;

  MyTeamModel({
    required this.success,
    required this.team,
  });

  factory MyTeamModel.fromJson(Map<String, dynamic> json) => MyTeamModel(
    success: json["success"],
    team: List<TeamData>.from(json["team"].map((x) => TeamData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "team": List<dynamic>.from(team.map((x) => x.toJson())),
  };
}

class TeamData {
  final User user;
  final double totalEarningsFromShare2;
  final List<Lead> leads;
  final int activeLeadCount;
  final int completeLeadCount;
  final int activeTeamCount;
  final int inactiveTeamCount;
  final List<TeamMember> team;

  TeamData({
    required this.user,
    required this.totalEarningsFromShare2,
    required this.leads,
    required this.activeLeadCount,
    required this.completeLeadCount,
    required this.activeTeamCount,
    required this.inactiveTeamCount,
    required this.team,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) => TeamData(
    user: User.fromJson(json["user"]),
    totalEarningsFromShare2: (json["totalEarningsFromShare_2"] ?? 0).toDouble(),
    leads: List<Lead>.from(json["leads"].map((x) => Lead.fromJson(x))),
    activeLeadCount: json["activeLeadCount"] ?? 0,
    completeLeadCount: json["completeLeadCount"] ?? 0,
    activeTeamCount: json["activeTeamCount"] ?? 0,
    inactiveTeamCount: json["inactiveTeamCount"] ?? 0,
    team: List<TeamMember>.from(json["team"].map((x) => TeamMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "totalEarningsFromShare_2": totalEarningsFromShare2,
    "leads": List<dynamic>.from(leads.map((x) => x.toJson())),
    "activeLeadCount": activeLeadCount,
    "completeLeadCount": completeLeadCount,
    "activeTeamCount": activeTeamCount,
    "inactiveTeamCount": inactiveTeamCount,
    "team": List<dynamic>.from(team.map((x) => x.toJson())),
  };
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final bool personalDetailsCompleted;
  final bool additionalDetailsCompleted;
  final bool addressCompleted;
  final String referralCode;
  final String? referredBy;
  final List<String> myTeams;
  final bool isAgree;
  final bool isEmailVerified;
  final bool isMobileVerified;
  final List<String> serviceCustomers;
  final int packageAmountPaid;
  final int remainingAmount;
  final String? packageType;
  final bool packageActive;
  final bool isCommissionDistribute;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final int packagePrice;
  final String? profilePhoto;
  final String? bloodGroup;
  final String? dateOfBirth;
  final String? education;
  final String? emergencyContact;
  final String? gender;
  final String? maritalStatus;
  final String? profession;
  final HomeAddress? homeAddress;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.personalDetailsCompleted,
    required this.additionalDetailsCompleted,
    required this.addressCompleted,
    required this.referralCode,
    this.referredBy,
    required this.myTeams,
    required this.isAgree,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.serviceCustomers,
    required this.packageAmountPaid,
    required this.remainingAmount,
    this.packageType,
    required this.packageActive,
    required this.isCommissionDistribute,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.packagePrice,
    this.profilePhoto,
    this.bloodGroup,
    this.dateOfBirth,
    this.education,
    this.emergencyContact,
    this.gender,
    this.maritalStatus,
    this.profession,
    this.homeAddress,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    fullName: json["fullName"],
    email: json["email"],
    mobileNumber: json["mobileNumber"],
    personalDetailsCompleted: json["personalDetailsCompleted"] ?? false,
    additionalDetailsCompleted: json["additionalDetailsCompleted"] ?? false,
    addressCompleted: json["addressCompleted"] ?? false,
    referralCode: json["referralCode"] ?? "",
    referredBy: json["referredBy"],
    myTeams: List<String>.from(json["myTeams"].map((x) => x)),
    isAgree: json["isAgree"] ?? false,
    isEmailVerified: json["isEmailVerified"] ?? false,
    isMobileVerified: json["isMobileVerified"] ?? false,
    serviceCustomers: List<String>.from(json["serviceCustomers"].map((x) => x)),
    packageAmountPaid: json["packageAmountPaid"] ?? 0,
    remainingAmount: json["remainingAmount"] ?? 0,
    packageType: json["packageType"],
    packageActive: json["packageActive"] ?? false,
    isCommissionDistribute: json["isCommissionDistribute"] ?? false,
    isDeleted: json["isDeleted"] ?? false,
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
    userId: json["userId"] ?? "",
    packagePrice: json["packagePrice"] ?? 0,
    profilePhoto: json["profilePhoto"],
    bloodGroup: json["bloodGroup"],
    dateOfBirth: json["dateOfBirth"],
    education: json["education"],
    emergencyContact: json["emergencyContact"],
    gender: json["gender"],
    maritalStatus: json["maritalStatus"],
    profession: json["profession"],
    homeAddress: json["homeAddress"] != null ? HomeAddress.fromJson(json["homeAddress"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullName": fullName,
    "email": email,
    "mobileNumber": mobileNumber,
    "personalDetailsCompleted": personalDetailsCompleted,
    "additionalDetailsCompleted": additionalDetailsCompleted,
    "addressCompleted": addressCompleted,
    "referralCode": referralCode,
    "referredBy": referredBy,
    "myTeams": List<dynamic>.from(myTeams.map((x) => x)),
    "isAgree": isAgree,
    "isEmailVerified": isEmailVerified,
    "isMobileVerified": isMobileVerified,
    "serviceCustomers": List<dynamic>.from(serviceCustomers.map((x) => x)),
    "packageAmountPaid": packageAmountPaid,
    "remainingAmount": remainingAmount,
    "packageType": packageType,
    "packageActive": packageActive,
    "isCommissionDistribute": isCommissionDistribute,
    "isDeleted": isDeleted,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "userId": userId,
    "packagePrice": packagePrice,
    "profilePhoto": profilePhoto,
    "bloodGroup": bloodGroup,
    "dateOfBirth": dateOfBirth,
    "education": education,
    "emergencyContact": emergencyContact,
    "gender": gender,
    "maritalStatus": maritalStatus,
    "profession": profession,
    "homeAddress": homeAddress?.toJson(),
  };
}

class HomeAddress {
  final String houseNumber;
  final String landmark;
  final String state;
  final String city;
  final String pinCode;
  final String country;
  final String fullAddress;

  HomeAddress({
    required this.houseNumber,
    required this.landmark,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.country,
    required this.fullAddress,
  });

  factory HomeAddress.fromJson(Map<String, dynamic> json) => HomeAddress(
    houseNumber: json["houseNumber"] ?? "",
    landmark: json["landmark"] ?? "",
    state: json["state"] ?? "",
    city: json["city"] ?? "",
    pinCode: json["pinCode"] ?? "",
    country: json["country"] ?? "",
    fullAddress: json["fullAddress"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "houseNumber": houseNumber,
    "landmark": landmark,
    "state": state,
    "city": city,
    "pinCode": pinCode,
    "country": country,
    "fullAddress": fullAddress,
  };
}

class Lead {
  final String checkoutId;
  final String leadId;
  final String status;
  final double amount;
  final double commissionEarned;

  Lead({
    required this.checkoutId,
    required this.leadId,
    required this.status,
    required this.amount,
    required this.commissionEarned,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    checkoutId: json["checkoutId"] ?? "",
    leadId: json["leadId"] ?? "",
    status: json["status"] ?? "",
    amount: (json["amount"] ?? 0).toDouble(),
    commissionEarned: (json["commissionEarned"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "checkoutId": checkoutId,
    "leadId": leadId,
    "status": status,
    "amount": amount,
    "commissionEarned": commissionEarned,
  };
}

class TeamMember {
  final User user;
  final double totalEarningsFromShare3;
  final List<Lead> leads;
  final int activeLeadCount;
  final int completeLeadCount;

  TeamMember({
    required this.user,
    required this.totalEarningsFromShare3,
    required this.leads,
    required this.activeLeadCount,
    required this.completeLeadCount,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    user: User.fromJson(json["user"]),
    totalEarningsFromShare3: (json["totalEarningsFromShare_3"] ?? 0).toDouble(),
    leads: List<Lead>.from(json["leads"].map((x) => Lead.fromJson(x))),
    activeLeadCount: json["activeLeadCount"] ?? 0,
    completeLeadCount: json["completeLeadCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "totalEarningsFromShare_3": totalEarningsFromShare3,
    "leads": List<dynamic>.from(leads.map((x) => x.toJson())),
    "activeLeadCount": activeLeadCount,
    "completeLeadCount": completeLeadCount,
  };
}
