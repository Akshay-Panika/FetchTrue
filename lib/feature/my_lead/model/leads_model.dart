import '../../service/model/service_model.dart';

class LeadsModel {
  final String id;
  final String bookingId;
  final String userId;
  final String paymentStatus;
  final String orderStatus;
  final String commission;
  final double totalAmount;
  final double subtotal;
  final int serviceDiscount;
  final int couponDiscount;
  final int champaignDiscount;
  final int gst;
  final int platformFee;
  final int assurityFee;
  final double walletAmount; // changed to double
  final double otherAmount;  // changed to double
  final double paidAmount;   // changed to double
  final double remainingAmount; // changed to double
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

  final double? listingPrice; // changed to double
  final double? serviceDiscountPrice; // changed to double
  final double? priceAfterDiscount; // changed to double
  final double? couponDiscountPrice; // changed to double
  final double? serviceGSTPrice; // changed to double
  final double? platformFeePrice; // changed to double
  final double? assurityChargesPrice; // changed to double

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
    required this.commission,
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
      commission: json['commission'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      serviceDiscount: json['serviceDiscount'] ?? 0,
      couponDiscount: json['couponDiscount'] ?? 0,
      champaignDiscount: json['champaignDiscount'] ?? 0,
      gst: json['gst'] ?? 0,
      platformFee: json['platformFee'] ?? 0,
      assurityFee: json['assurityfee'] ?? 0,
      walletAmount: (json['walletAmount'] as num?)?.toDouble() ?? 0.0,
      otherAmount: (json['otherAmount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,
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
      listingPrice: (json['listingPrice'] as num?)?.toDouble(),
      serviceDiscountPrice: (json['serviceDiscountPrice'] as num?)?.toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble(),
      couponDiscountPrice: (json['couponDiscountPrice'] as num?)?.toDouble(),
      serviceGSTPrice: (json['serviceGSTPrice'] as num?)?.toDouble(),
      platformFeePrice: (json['platformFeePrice'] as num?)?.toDouble(),
      assurityChargesPrice: (json['assurityChargesPrice'] as num?)?.toDouble(),
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

