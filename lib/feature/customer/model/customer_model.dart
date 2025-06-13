class CustomerModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String country;
  final String userId;
  final String customerId;
  final bool isDeleted;
  final bool isOtpVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.userId,
    required this.customerId,
    required this.isDeleted,
    required this.isOtpVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['_id'],
      fullName: json['fullName'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      userId: json['user'],
      customerId: json['customerId'],
      isDeleted: json['isDeleted'],
      isOtpVerified: json['otp']?['verified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'user': userId,
      'customerId': customerId,
      'isDeleted': isDeleted,
      'otp': {'verified': isOtpVerified},
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
