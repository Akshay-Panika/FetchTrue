class LeadsModel {
  final String id;
  final String bookingId;
  final String userId;
  final String paymentStatus;
  final String orderStatus;
  final int totalAmount;
  final int subtotal;
  final int serviceDiscount;
  final int couponDiscount;
  final int champaignDiscount;
  final int gst;
  final int platformFee;
  final int assurityFee;
  final int walletAmount;
  final int otherAmount;
  final int paidAmount;
  final int remainingAmount;
  final bool isPartialPayment;
  final bool isVerified;
  final bool isAccepted;
  final String? acceptedDate;
  final bool isOtpVerified;
  final bool isCompleted;
  final bool commissionDistributed;
  final bool isCanceled;
  final bool isDeleted;
  final String otp;
  final String notes;
  final bool termsCondition;
  final String createdAt;
  final String updatedAt;

  final int? listingPrice;
  final int? serviceDiscountPrice;
  final int? priceAfterDiscount;
  final int? couponDiscountPrice;
  final int? serviceGSTPrice;
  final int? platformFeePrice;
  final int? assurityChargesPrice;

  // Nested objects
  final ServiceModel service;
  final ServiceCustomerModel serviceCustomer;
  final String? provider;
  final String? serviceMan;
  final String? coupon;
  final List<String> paymentMethod;

  LeadsModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.paymentStatus,
    required this.orderStatus,
    required this.totalAmount,
    required this.subtotal,
    required this.serviceDiscount,
    required this.couponDiscount,
    required this.champaignDiscount,
    required this.gst,
    required this.platformFee,
    required this.assurityFee,
    required this.walletAmount,
    required this.otherAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.isPartialPayment,
    required this.isVerified,
    required this.isAccepted,
    this.acceptedDate,
    required this.isOtpVerified,
    required this.isCompleted,
    required this.commissionDistributed,
    required this.isCanceled,
    required this.isDeleted,
    required this.otp,
    required this.notes,
    required this.termsCondition,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
    required this.serviceCustomer,
    this.provider,
    this.serviceMan,
    this.coupon,
    required this.paymentMethod,

    this.listingPrice,
    this.serviceDiscountPrice,
    this.priceAfterDiscount,
    this.couponDiscountPrice,
    this.serviceGSTPrice,
    this.platformFeePrice,
    this.assurityChargesPrice,
  });

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    return LeadsModel(
      id: json['_id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      userId: json['user'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      totalAmount: json['totalAmount'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      serviceDiscount: json['serviceDiscount'] ?? 0,
      couponDiscount: json['couponDiscount'] ?? 0,
      champaignDiscount: json['champaignDiscount'] ?? 0,
      gst: json['gst'] ?? 0,
      platformFee: json['platformFee'] ?? 0,
      assurityFee: json['assurityfee'] ?? 0,
      walletAmount: json['walletAmount'] ?? 0,
      otherAmount: json['otherAmount'] ?? 0,
      paidAmount: json['paidAmount'] ?? 0,
      remainingAmount: json['remainingAmount'] ?? 0,
      isPartialPayment: json['isPartialPayment'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isAccepted: json['isAccepted'] ?? false,
      acceptedDate: json['acceptedDate'],
      isOtpVerified: json['isOtpVerified'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      commissionDistributed: json['commissionDistributed'] ?? false,
      isCanceled: json['isCanceled'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      otp: json['otp'] ?? '',
      notes: json['notes'] ?? '',
      termsCondition: json['termsCondition'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      service: ServiceModel.fromJson(json['service'] ?? {}),
      serviceCustomer: ServiceCustomerModel.fromJson(json['serviceCustomer'] ?? {}),
      provider: json['provider'],
      serviceMan: json['serviceMan'],
      coupon: json['coupon'],
      paymentMethod: List<String>.from(json['paymentMethod'] ?? []),

      listingPrice: json['listingPrice'],
      serviceDiscountPrice: json['serviceDiscountPrice'],
      priceAfterDiscount: json['priceAfterDiscount'],
      couponDiscountPrice: json['couponDiscountPrice'],
      serviceGSTPrice: json['serviceGSTPrice'],
      platformFeePrice: json['platformFeePrice'],
      assurityChargesPrice: json['assurityChargesPrice'],
    );
  }
}

class ServiceModel {
  final String id;
  final String serviceName;
  final int price;
  final int discount;
  final double discountedPrice;
  final FranchiseDetails? franchiseDetails;


  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.franchiseDetails,

  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final int price = json['price'] ?? 0;
    final int discount = json['discount'] ?? 0;

    final double discountedPrice = json.containsKey('discountedPrice')
        ? (json['discountedPrice'] as num).toDouble()
        : price - ((discount / 100) * price);

    return ServiceModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      price: price,
      discount: discount,
      discountedPrice: double.parse(discountedPrice.toStringAsFixed(2)),
      franchiseDetails: json['franchiseDetails'] != null
          ? FranchiseDetails.fromJson(json['franchiseDetails'])
          : null,
    );
  }

}

class FranchiseDetails {
  final String? commission;

  FranchiseDetails({this.commission});

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'],
    );
  }
}

class ServiceCustomerModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String country;
  final String customerId;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final bool otpVerified;

  ServiceCustomerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.customerId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.otpVerified,
  });

  factory ServiceCustomerModel.fromJson(Map<String, dynamic> json) {
    return ServiceCustomerModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      customerId: json['customerId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      otpVerified: json['otp']?['verified'] ?? false,
    );
  }
}

