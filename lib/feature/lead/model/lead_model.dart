class LeadModel {
  final bool? success;
  final List<BookingData>? data;

  LeadModel({this.success, this.data});

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BookingData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BookingData {
  final String? id;
  final String? user;
  final Service? service;
  final ServiceCustomer? serviceCustomer;
  final dynamic provider;
  final dynamic serviceMan;
  final dynamic coupon;
  final num? subtotal;
  final num? serviceDiscount;
  final num? couponDiscount;
  final num? champaignDiscount;
  final num? gst;
  final num? platformFee;
  final num? assurityfee;
  final num? listingPrice;
  final num? serviceDiscountPrice;
  final num? priceAfterDiscount;
  final num? couponDiscountPrice;
  final num? serviceGSTPrice;
  final num? platformFeePrice;
  final num? assurityChargesPrice;
  final num? extraServicePrice;
  final String? commission;
  final String? couponDiscountType;
  final num? totalAmount;
  final num? grandTotal;
  final List<String>? paymentMethod;
  final num? walletAmount;
  final dynamic otherAmount;
  final num? paidAmount;
  final bool? isPartialPayment;
  final dynamic remainingAmount;
  final dynamic cashfreeMethod;
  final String? paymentStatus;
  final dynamic orderStatus;
  final bool? cashInHand;
  final num? cashInHandAmount;
  final String? notes;
  final bool? termsCondition;
  final bool? isVerified;
  final bool? isAccepted;
  final dynamic acceptedDate;
  final bool? isOtpVerified;
  final bool? isCompleted;
  final bool? commissionDistributed;
  final bool? isCanceled;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? bookingId;
  final String? otp;
  final num? v;

  BookingData({
    this.id,
    this.user,
    this.service,
    this.serviceCustomer,
    this.provider,
    this.serviceMan,
    this.coupon,
    this.subtotal,
    this.serviceDiscount,
    this.couponDiscount,
    this.champaignDiscount,
    this.gst,
    this.platformFee,
    this.assurityfee,
    this.listingPrice,
    this.serviceDiscountPrice,
    this.priceAfterDiscount,
    this.couponDiscountPrice,
    this.serviceGSTPrice,
    this.platformFeePrice,
    this.assurityChargesPrice,
    this.extraServicePrice,
    this.commission,
    this.couponDiscountType,
    this.totalAmount,
    this.grandTotal,
    this.paymentMethod,
    this.walletAmount,
    this.otherAmount,
    this.paidAmount,
    this.isPartialPayment,
    this.remainingAmount,
    this.cashfreeMethod,
    this.paymentStatus,
    this.orderStatus,
    this.cashInHand,
    this.cashInHandAmount,
    this.notes,
    this.termsCondition,
    this.isVerified,
    this.isAccepted,
    this.acceptedDate,
    this.isOtpVerified,
    this.isCompleted,
    this.commissionDistributed,
    this.isCanceled,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.bookingId,
    this.otp,
    this.v,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      service: json['service'] != null ? Service.fromJson(json['service']) : null,
      serviceCustomer: json['serviceCustomer'] != null
          ? ServiceCustomer.fromJson(json['serviceCustomer'])
          : null,
      provider: json['provider'],
      serviceMan: json['serviceMan'],
      coupon: json['coupon'],
      subtotal: (json['subtotal'] as num?),
      serviceDiscount: (json['serviceDiscount'] as num?),
      couponDiscount: (json['couponDiscount'] as num?),
      champaignDiscount: (json['champaignDiscount'] as num?),
      gst: (json['gst'] as num?),
      platformFee: (json['platformFee'] as num?),
      assurityfee: (json['assurityfee'] as num?),
      listingPrice: (json['listingPrice'] as num?),
      serviceDiscountPrice: (json['serviceDiscountPrice'] as num?),
      priceAfterDiscount: (json['priceAfterDiscount'] as num?),
      couponDiscountPrice: (json['couponDiscountPrice'] as num?),
      serviceGSTPrice: (json['serviceGSTPrice'] as num?),
      platformFeePrice: (json['platformFeePrice'] as num?),
      assurityChargesPrice: (json['assurityChargesPrice'] as num?),
      extraServicePrice: (json['extraServicePrice'] as num?),
      commission: json['commission'] as String?,
      couponDiscountType: json['couponDiscountType'] as String?,
      totalAmount: (json['totalAmount'] as num?),
      grandTotal: (json['grandTotal'] as num?),
      paymentMethod: (json['paymentMethod'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      walletAmount: (json['walletAmount'] as num?),
      otherAmount: json['otherAmount'],
      paidAmount: (json['paidAmount'] as num?),
      isPartialPayment: json['isPartialPayment'] as bool?,
      remainingAmount: json['remainingAmount'],
      cashfreeMethod: json['cashfreeMethod'],
      paymentStatus: json['paymentStatus'] as String?,
      orderStatus: json['orderStatus'],
      cashInHand: json['cashInHand'] as bool?,
      cashInHandAmount: (json['cashInHandAmount'] as num?),
      notes: json['notes'] as String?,
      termsCondition: json['termsCondition'] as bool?,
      isVerified: json['isVerified'] as bool?,
      isAccepted: json['isAccepted'] as bool?,
      acceptedDate: json['acceptedDate'],
      isOtpVerified: json['isOtpVerified'] as bool?,
      isCompleted: json['isCompleted'] as bool?,
      commissionDistributed: json['commissionDistributed'] as bool?,
      isCanceled: json['isCanceled'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      bookingId: json['bookingId'] as String?,
      otp: json['otp'] as String?,
      v: (json['__v'] as num?),
    );
  }
}

class Service {
  final String? id;
  final String? serviceName;
  final num? price;
  final num? discount;
  final num? discountedPrice;

  Service({
    this.id,
    this.serviceName,
    this.price,
    this.discount,
    this.discountedPrice,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] as String?,
      serviceName: json['serviceName'] as String?,
      price: (json['price'] as num?),
      discount: (json['discount'] as num?),
      discountedPrice: (json['discountedPrice'] as num?),
    );
  }
}

class ServiceCustomer {
  final Otp? otp;
  final String? id;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? description;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? user;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? customerId;
  final num? v;

  ServiceCustomer({
    this.otp,
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.description,
    this.address,
    this.city,
    this.state,
    this.country,
    this.user,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.v,
  });

  factory ServiceCustomer.fromJson(Map<String, dynamic> json) {
    return ServiceCustomer(
      otp: json['otp'] != null ? Otp.fromJson(json['otp']) : null,
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      user: json['user'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      customerId: json['customerId'] as String?,
      v: (json['__v'] as num?),
    );
  }
}

class Otp {
  final bool? verified;

  Otp({this.verified});

  factory Otp.fromJson(Map<String, dynamic> json) {
    return Otp(
      verified: json['verified'] as bool?,
    );
  }
}
