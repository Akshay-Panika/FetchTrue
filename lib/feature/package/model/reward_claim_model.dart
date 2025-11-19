class ClaimNowDataModel {
  final String id;
  final UserModel user;
  final RewardModel? reward;
  final bool isClaimRequest;
  final bool isExtraMonthlyEarnRequest;
  final bool isAdminApproved;
  final String createdAt;

  ClaimNowDataModel({
    required this.id,
    required this.user,
    this.reward,
    required this.isClaimRequest,
    required this.isExtraMonthlyEarnRequest,
    required this.isAdminApproved,
    required this.createdAt,
  });

  factory ClaimNowDataModel.fromJson(Map<String, dynamic> json) {
    return ClaimNowDataModel(
      id: json["_id"],
      user: UserModel.fromJson(json["user"]),
      reward:
      json["reward"] != null ? RewardModel.fromJson(json["reward"]) : null,
      isClaimRequest: json["isClaimRequest"] ?? false,
      isExtraMonthlyEarnRequest: json["isExtraMonthlyEarnRequest"] ?? false,
      isAdminApproved: json["isAdminApproved"] ?? false,
      createdAt: json["createdAt"] ?? "",
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
    );
  }
}

class RewardModel {
  final String id;
  final String name;
  final String photo;
  final String description;

  RewardModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.description,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json["_id"],
      name: json["name"] ?? "",
      photo: json["photo"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
