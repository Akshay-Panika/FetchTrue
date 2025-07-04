class ProviderModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final String password;
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
  final List<SubscribedService> subscribedServices;

  ProviderModel({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.password,
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
    required this.subscribedServices,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['_id'],
      fullName: json['fullName'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      password: json['password'],
      isRejected: json['isRejected'],
      isApproved: json['isApproved'],
      isVerified: json['isVerified'],
      isDeleted: json['isDeleted'],
      step1Completed: json['step1Completed'],
      storeInfoCompleted: json['storeInfoCompleted'],
      kycCompleted: json['kycCompleted'],
      registrationStatus: json['registrationStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      storeInfo: json['storeInfo'] != null
          ? StoreInfo.fromJson(json['storeInfo'])
          : null,
      kyc: json['kyc'] != null ? KYC.fromJson(json['kyc']) : null,
      subscribedServices: (json['subscribedServices'] as List?)
          ?.map((e) => SubscribedService.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final String? module;
  final String? zone;
  final String logo;
  final String cover;
  final String address;
  final String? officeNo;
  final String city;
  final String state;
  final String country;
  final String? tax;
  final Location? location;

  StoreInfo({
    required this.storeName,
    required this.storePhone,
    required this.storeEmail,
    this.module,
    this.zone,
    required this.logo,
    required this.cover,
    required this.address,
    this.officeNo,
    required this.city,
    required this.state,
    required this.country,
    this.tax,
    this.location,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      storeName: json['storeName'],
      storePhone: json['storePhone'],
      storeEmail: json['storeEmail'],
      module: json['module'],
      zone: json['zone'],
      logo: json['logo'] ?? '',
      cover: json['cover'] ?? '',
      address: json['address'],
      officeNo: json['officeNo'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      tax: json['tax'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((e) => e.toDouble())),
    );
  }
}

class KYC {
  final List<String> aadhaarCard;
  final List<String> panCard;
  final List<String> storeDocument;
  final List<String> gst;
  final List<String> other;

  KYC({
    required this.aadhaarCard,
    required this.panCard,
    required this.storeDocument,
    required this.gst,
    required this.other,
  });

  factory KYC.fromJson(Map<String, dynamic> json) {
    return KYC(
      aadhaarCard: List<String>.from(json['aadhaarCard'] ?? []),
      panCard: List<String>.from(json['panCard'] ?? []),
      storeDocument: List<String>.from(json['storeDocument'] ?? []),
      gst: List<String>.from(json['GST'] ?? []),
      other: List<String>.from(json['other'] ?? []),
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
      id: json['_id'],
      serviceName: json['serviceName'],
      price: json['price'],
      discountedPrice: json['discountedPrice'],
      isDeleted: json['isDeleted'],
    );
  }
}
