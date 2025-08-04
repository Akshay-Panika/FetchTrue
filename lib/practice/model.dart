class UModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String profilePhoto;
  final bool personalDetailsCompleted;
  final bool additionalDetailsCompleted;
  final bool addressCompleted;

  UModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.profilePhoto,
    required this.personalDetailsCompleted,
    required this.additionalDetailsCompleted,
    required this.addressCompleted,
  });

  factory UModel.fromJson(Map<String, dynamic> json) {
    return UModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      profilePhoto: json['profilePhoto'] ?? '',
      personalDetailsCompleted: json['personalDetailsCompleted'] ?? false,
      additionalDetailsCompleted: json['additionalDetailsCompleted'] ?? false,
      addressCompleted: json['addressCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "mobileNumber": mobileNumber,
    "profilePhoto": profilePhoto,
    "personalDetailsCompleted": personalDetailsCompleted,
    "additionalDetailsCompleted": additionalDetailsCompleted,
    "addressCompleted": addressCompleted,
  };
}
