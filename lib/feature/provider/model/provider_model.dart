// class ProviderModel {
//   final String id;
//   final String fullName;
//   final String phoneNo;
//   final String email;
//
//   ProviderModel({
//     required this.id,
//     required this.fullName,
//     required this.phoneNo,
//     required this.email,
//   });
//
//   factory ProviderModel.fromJson(Map<String, dynamic> json) {
//     return ProviderModel(
//       id: json['_id'] ?? '',
//       fullName: json['fullName'] ?? '',
//       phoneNo: json['phoneNo'] ?? '',
//       email: json['email'] ?? '',
//     );
//   }
// }


class ProviderModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final String password;
  final List<SubscribedService> subscribedServices;
  final bool isRejected;
  final bool isApproved;
  final bool isVerified;
  final bool isDeleted;
  final bool step1Completed;
  final bool storeInfoCompleted;
  final bool kycCompleted;
  final String registrationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final StoreInfo? storeInfo;
  final KYC? kyc;

  ProviderModel({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.subscribedServices,
    required this.isRejected,
    required this.isApproved,
    required this.isVerified,
    required this.isDeleted,
    required this.step1Completed,
    required this.storeInfoCompleted,
    required this.kycCompleted,
    required this.registrationStatus,
    required this.createdAt,
    required this.updatedAt,
    this.storeInfo,
    this.kyc,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      subscribedServices: (json['subscribedServices'] as List?)
          ?.map((e) => SubscribedService.fromJson(e))
          .toList() ??
          [],
      isRejected: json['isRejected'] ?? false,
      isApproved: json['isApproved'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      step1Completed: json['step1Completed'] ?? false,
      storeInfoCompleted: json['storeInfoCompleted'] ?? false,
      kycCompleted: json['kycCompleted'] ?? false,
      registrationStatus: json['registrationStatus'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      storeInfo: json['storeInfo'] != null
          ? StoreInfo.fromJson(json['storeInfo'])
          : null,
      kyc: json['kyc'] != null ? KYC.fromJson(json['kyc']) : null,
    );
  }
}

class SubscribedService {
  final String id;
  final String serviceName;
  final int price;
  final int? discountedPrice;
  final bool isDeleted;

  SubscribedService({
    required this.id,
    required this.serviceName,
    required this.price,
    this.discountedPrice,
    required this.isDeleted,
  });

  factory SubscribedService.fromJson(Map<String, dynamic> json) {
    return SubscribedService(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      price: json['price'] ?? 0,
      discountedPrice: json['discountedPrice'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final String module;
  final String zone;
  final String logo;
  final String cover;
  final String address;
  final String city;
  final String state;
  final String country;

  StoreInfo({
    required this.storeName,
    required this.storePhone,
    required this.storeEmail,
    required this.module,
    required this.zone,
    required this.logo,
    required this.cover,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      storeName: json['storeName'] ?? '',
      storePhone: json['storePhone'] ?? '',
      storeEmail: json['storeEmail'] ?? '',
      module: json['module'] ?? '',
      zone: json['zone'] ?? '',
      logo: json['logo'] ?? '',
      cover: json['cover'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class KYC {
  final List<String> aadhaarCard;
  final List<String> panCard;
  final List<String> storeDocument;
  final List<String> GST;
  final List<String> other;

  KYC({
    required this.aadhaarCard,
    required this.panCard,
    required this.storeDocument,
    required this.GST,
    required this.other,
  });

  factory KYC.fromJson(Map<String, dynamic> json) {
    return KYC(
      aadhaarCard: List<String>.from(json['aadhaarCard'] ?? []),
      panCard: List<String>.from(json['panCard'] ?? []),
      storeDocument: List<String>.from(json['storeDocument'] ?? []),
      GST: List<String>.from(json['GST'] ?? []),
      other: List<String>.from(json['other'] ?? []),
    );
  }
}

