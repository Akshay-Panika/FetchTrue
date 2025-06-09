class ProviderModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final String password;
  final String referralCode;
  final String? referredBy;
  final StoreInfo storeInfo;
  final KYC kyc;
  final bool isVerified;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> subscribedServices;

  ProviderModel({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.referralCode,
    this.referredBy,
    required this.storeInfo,
    required this.kyc,
    required this.isVerified,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.subscribedServices,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
    id: json['_id'],
    fullName: json['fullName'],
    phoneNo: json['phoneNo'],
    email: json['email'],
    password: json['password'],
    referralCode: json['referralCode'],
    referredBy: json['referredBy'],
    storeInfo: StoreInfo.fromJson(json['storeInfo']),
    kyc: KYC.fromJson(json['kyc']),
    isVerified: json['isVerified'],
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    subscribedServices: List<String>.from(json['subscribedServices']),
  );
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final Module module;
  final Zone zone;
  final String? logo;
  final String? cover;
  final String tax;
  final Location location;
  final String address;
  final String officeNo;
  final String city;
  final String state;
  final String country;

  StoreInfo({
    required this.storeName,
    required this.storePhone,
    required this.storeEmail,
    required this.module,
    required this.zone,
    this.logo,
    this.cover,
    required this.tax,
    required this.location,
    required this.address,
    required this.officeNo,
    required this.city,
    required this.state,
    required this.country,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) => StoreInfo(
    storeName: json['storeName'],
    storePhone: json['storePhone'],
    storeEmail: json['storeEmail'],
    module: Module.fromJson(json['module']),
    zone: Zone.fromJson(json['zone']),
    logo: json['logo'],
    cover: json['cover'],
    tax: json['tax'],
    location: Location.fromJson(json['location']),
    address: json['address'],
    officeNo: json['officeNo'],
    city: json['city'],
    state: json['state'],
    country: json['country'],
  );
}
class Module {
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Module({
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    id: json['_id'],
    name: json['name'],
    image: json['image'],
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

class Zone {
  final String id;
  final String name;
  final List<LatLngPoint> coordinates;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Zone({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    id: json['_id'],
    name: json['name'],
    coordinates: List<LatLngPoint>.from(
      json['coordinates'].map((x) => LatLngPoint.fromJson(x)),
    ),
    isDeleted: json['isDeleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

class LatLngPoint {
  final double lat;
  final double lng;

  LatLngPoint({
    required this.lat,
    required this.lng,
  });

  factory LatLngPoint.fromJson(Map<String, dynamic> json) => LatLngPoint(
    lat: json['lat'],
    lng: json['lng'],
  );
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json['type'],
    coordinates: List<double>.from(json['coordinates']),
  );
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

  factory KYC.fromJson(Map<String, dynamic> json) => KYC(
    aadhaarCard: List<String>.from(json['aadhaarCard']),
    panCard: List<String>.from(json['panCard']),
    storeDocument: List<String>.from(json['storeDocument']),
    GST: List<String>.from(json['GST']),
    other: List<String>.from(json['other']),
  );
}
