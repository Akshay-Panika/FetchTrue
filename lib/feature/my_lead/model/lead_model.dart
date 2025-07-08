class LeadModel {
  final String id;
  final User user;
  final Service service;
  final ServiceCustomer serviceCustomer;
  final dynamic provider;
  final dynamic coupon;
  final int subtotal;
  final int serviceDiscount;
  final int couponDiscount;
  final int champaignDiscount;
  final int vat;
  final int platformFee;
  final int garrentyFee;
  final int tax;
  final bool termsCondition;
  final int totalAmount;
  final List<String> paymentMethod;
  final int walletAmount;
  final int paidByOtherMethodAmount;
  final String paymentStatus;
  final String orderStatus;
  final String notes;
  final bool isVerified;
  final bool isAccepted;
  final bool isCompleted;
  final bool isCanceled;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final String bookingId;
  final String? acceptedDate;


  LeadModel({
    required this.id,
    required this.user,
    required this.service,
    required this.serviceCustomer,
    required this.provider,
    required this.coupon,
    required this.subtotal,
    required this.serviceDiscount,
    required this.couponDiscount,
    required this.champaignDiscount,
    required this.vat,
    required this.platformFee,
    required this.garrentyFee,
    required this.tax,
    required this.termsCondition,
    required this.totalAmount,
    required this.paymentMethod,
    required this.walletAmount,
    required this.paidByOtherMethodAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.notes,
    required this.isVerified,
    required this.isAccepted,
    required this.isCompleted,
    required this.isCanceled,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingId,
    this.acceptedDate,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      service: Service.fromJson(json['service'] ?? {}),
      serviceCustomer: ServiceCustomer.fromJson(json['serviceCustomer'] ?? {}),
      provider: json['provider'],
      coupon: json['coupon'],
      subtotal: json['subtotal'] ?? 0,
      serviceDiscount: json['serviceDiscount'] ?? 0,
      couponDiscount: json['couponDiscount'] ?? 0,
      champaignDiscount: json['champaignDiscount'] ?? 0,
      vat: json['vat'] ?? 0,
      platformFee: json['platformFee'] ?? 0,
      garrentyFee: json['garrentyFee'] ?? 0,
      tax: json['tax'] ?? 0,
      termsCondition: json['termsCondition'] ?? false,
      totalAmount: json['totalAmount'] ?? 0,
      paymentMethod: List<String>.from(json['paymentMethod'] ?? []),
      walletAmount: json['walletAmount'] ?? 0,
      paidByOtherMethodAmount: json['paidByOtherMethodAmount'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      notes: json['notes'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isAccepted: json['isAccepted'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      isCanceled: json['isCanceled'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      bookingId: json['bookingId'] ?? '',
      acceptedDate: json['acceptedDate'] ?? '',

    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
    );
  }
}

class Service {
  final String id;
  final String serviceName;
  final int price;
  final int discount;
  final int discountedPrice;

  Service({
    required this.id,
    required this.serviceName,
    required this.discount,
    required this.price,
    required this.discountedPrice,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
    );
  }
}

class ServiceCustomer {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String city;


  ServiceCustomer({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.city,
  });

  factory ServiceCustomer.fromJson(Map<String, dynamic> json) {
    return ServiceCustomer(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] ?? '',
    );
  }
}