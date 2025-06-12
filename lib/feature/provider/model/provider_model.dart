class ProviderModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;

  ProviderModel({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
