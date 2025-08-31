import 'dart:convert';

class MyTeamModel {
  final bool success;
  final List<TeamData> team;

  MyTeamModel({
    required this.success,
    required this.team,
  });

  factory MyTeamModel.fromJson(Map<String, dynamic> json) {
    return MyTeamModel(
      success: json['success'] ?? false,
      team: (json['team'] as List<dynamic>? ?? [])
          .map((e) => TeamData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "team": team.map((e) => e.toJson()).toList(),
    };
  }
}

class TeamData {
  final User? user;
  final double? totalEarningsFromShare2;
  final List<Lead> leads;
  final int activeLeadCount;
  final int completeLeadCount;
  final int activeTeamCount;
  final int inactiveTeamCount;
  final List<SubTeam> team;

  TeamData({
    this.user,
    this.totalEarningsFromShare2,
    required this.leads,
    required this.activeLeadCount,
    required this.completeLeadCount,
    required this.activeTeamCount,
    required this.inactiveTeamCount,
    required this.team,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      totalEarningsFromShare2: (json['totalEarningsFromShare_2'] ?? 0).toDouble(),
      leads: (json['leads'] as List<dynamic>? ?? [])
          .map((e) => Lead.fromJson(e))
          .toList(),
      activeLeadCount: json['activeLeadCount'] ?? 0,
      completeLeadCount: json['completeLeadCount'] ?? 0,
      activeTeamCount: json['activeTeamCount'] ?? 0,
      inactiveTeamCount: json['inactiveTeamCount'] ?? 0,
      team: (json['team'] as List<dynamic>? ?? [])
          .map((e) => SubTeam.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user?.toJson(),
      "totalEarningsFromShare_2": totalEarningsFromShare2,
      "leads": leads.map((e) => e.toJson()).toList(),
      "activeLeadCount": activeLeadCount,
      "completeLeadCount": completeLeadCount,
      "activeTeamCount": activeTeamCount,
      "inactiveTeamCount": inactiveTeamCount,
      "team": team.map((e) => e.toJson()).toList(),
    };
  }
}

class SubTeam {
  final User? user;
  final double? totalEarningsFromShare3;
  final List<Lead> leads;
  final int activeLeadCount;
  final int completeLeadCount;

  SubTeam({
    this.user,
    this.totalEarningsFromShare3,
    required this.leads,
    required this.activeLeadCount,
    required this.completeLeadCount,
  });

  factory SubTeam.fromJson(Map<String, dynamic> json) {
    return SubTeam(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      totalEarningsFromShare3: (json['totalEarningsFromShare_3'] ?? 0).toDouble(),
      leads: (json['leads'] as List<dynamic>? ?? [])
          .map((e) => Lead.fromJson(e))
          .toList(),
      activeLeadCount: json['activeLeadCount'] ?? 0,
      completeLeadCount: json['completeLeadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user?.toJson(),
      "totalEarningsFromShare_3": totalEarningsFromShare3,
      "leads": leads.map((e) => e.toJson()).toList(),
      "activeLeadCount": activeLeadCount,
      "completeLeadCount": completeLeadCount,
    };
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String? userId;
  final String? referralCode;
  final String? profilePhoto;
  final bool isEmailVerified;
  final bool isMobileVerified;
  final bool packageActive;
  final String? packageStatus;
  final int packagePrice;
  final int packageAmountPaid;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    this.userId,
    this.referralCode,
    this.profilePhoto,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.packageActive,
    this.packageStatus,
    required this.packagePrice,
    required this.packageAmountPaid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      userId: json['userId'],
      referralCode: json['referralCode'],
      profilePhoto: json['profilePhoto'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isMobileVerified: json['isMobileVerified'] ?? false,
      packageActive: json['packageActive'] ?? false,
      packageStatus: json['packageStatus'],
      packagePrice: json['packagePrice'] ?? 0,
      packageAmountPaid: json['packageAmountPaid'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullName": fullName,
      "email": email,
      "mobileNumber": mobileNumber,
      "userId": userId,
      "referralCode": referralCode,
      "profilePhoto": profilePhoto,
      "isEmailVerified": isEmailVerified,
      "isMobileVerified": isMobileVerified,
      "packageActive": packageActive,
      "packageStatus": packageStatus,
      "packagePrice": packagePrice,
      "packageAmountPaid": packageAmountPaid,
    };
  }
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

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      checkoutId: json['checkoutId'] ?? '',
      leadId: json['leadId'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      commissionEarned: (json['commissionEarned'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "checkoutId": checkoutId,
      "leadId": leadId,
      "status": status,
      "amount": amount,
      "commissionEarned": commissionEarned,
    };
  }
}
