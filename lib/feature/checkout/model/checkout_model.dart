

class CheckOutModel {
  final String? user;
  final String? service;
  final String? serviceCustomer;
  final String? provider;
  final String? serviceMan;
  final String? coupon;
  final int? subtotal;
  final int? serviceDiscount;
  final int? couponDiscount;
  final int? champaignDiscount;
  final int? gst;
  final int? platformFee;
  final int? assurityfee;
  final int? totalAmount;
  final List<String>? paymentMethod;
  final int? walletAmount;
  final int? otherAmount;
  final int? paidAmount;
  final bool? isPartialPayment;
  final int? remainingAmount;
  final String? paymentStatus;
  final String? orderStatus;
  final String? notes;
  final bool? termsCondition;
  final bool? isVerified;
  final bool? isAccepted;
  final bool? isOtpVerified;
  final bool? isCompleted;
  final bool? commissionDistributed;
  final bool? isCanceled;
  final bool? isDeleted;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? bookingId;
  final String? otp;

  // ✅ Extra calculated fields
  final int? listingPrice;
  final int? serviceDiscountPrice;
  final int? priceAfterDiscount;
  final int? couponDiscountPrice;
  final int? serviceGSTPrice;
  final int? platformFeePrice;
  final int? assurityChargesPrice;

  CheckOutModel({
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
    this.totalAmount,
    this.paymentMethod,
    this.walletAmount,
    this.otherAmount,
    this.paidAmount,
    this.isPartialPayment,
    this.remainingAmount,
    this.paymentStatus,
    this.orderStatus,
    this.notes,
    this.termsCondition,
    this.isVerified,
    this.isAccepted,
    this.isOtpVerified,
    this.isCompleted,
    this.commissionDistributed,
    this.isCanceled,
    this.isDeleted,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.bookingId,
    this.otp,
    this.listingPrice,
    this.serviceDiscountPrice,
    this.priceAfterDiscount,
    this.couponDiscountPrice,
    this.serviceGSTPrice,
    this.platformFeePrice,
    this.assurityChargesPrice,
  });

  factory CheckOutModel.fromJson(Map<String, dynamic> json) {
    return CheckOutModel(
      user: json['user'],
      service: json['service'],
      serviceCustomer: json['serviceCustomer'],
      provider: json['provider'],
      serviceMan: json['serviceMan'],
      coupon: json['coupon'],
      subtotal: json['subtotal'],
      serviceDiscount: json['serviceDiscount'],
      couponDiscount: json['couponDiscount'],
      champaignDiscount: json['champaignDiscount'],
      gst: json['gst'],
      platformFee: json['platformFee'],
      assurityfee: json['assurityfee'],
      totalAmount: json['totalAmount'],
      paymentMethod: List<String>.from(json['paymentMethod'] ?? []),
      walletAmount: json['walletAmount'],
      otherAmount: json['otherAmount'],
      paidAmount: json['paidAmount'],
      isPartialPayment: json['isPartialPayment'],
      remainingAmount: json['remainingAmount'],
      paymentStatus: json['paymentStatus'],
      orderStatus: json['orderStatus'],
      notes: json['notes'],
      termsCondition: json['termsCondition'],
      isVerified: json['isVerified'],
      isAccepted: json['isAccepted'],
      isOtpVerified: json['isOtpVerified'],
      isCompleted: json['isCompleted'],
      commissionDistributed: json['commissionDistributed'],
      isCanceled: json['isCanceled'],
      isDeleted: json['isDeleted'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      bookingId: json['bookingId'],
      otp: json['otp'],
      listingPrice: json['listingPrice'],
      serviceDiscountPrice: json['serviceDiscountPrice'],
      priceAfterDiscount: json['priceAfterDiscount'],
      couponDiscountPrice: json['couponDiscountPrice'],
      serviceGSTPrice: json['serviceGSTPrice'],
      platformFeePrice: json['platformFeePrice'],
      assurityChargesPrice: json['assurityChargesPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'service': service,
      'serviceCustomer': serviceCustomer,
      'provider': provider,
      'serviceMan': serviceMan,
      'coupon': coupon,
      'subtotal': subtotal,
      'serviceDiscount': serviceDiscount,
      'couponDiscount': couponDiscount,
      'champaignDiscount': champaignDiscount,
      'gst': gst,
      'platformFee': platformFee,
      'assurityfee': assurityfee,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'walletAmount': walletAmount,
      'otherAmount': otherAmount,
      'paidAmount': paidAmount,
      'isPartialPayment': isPartialPayment,
      'remainingAmount': remainingAmount,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'notes': notes,
      'termsCondition': termsCondition,
      'isVerified': isVerified,
      'isAccepted': isAccepted,
      'isOtpVerified': isOtpVerified,
      'isCompleted': isCompleted,
      'commissionDistributed': commissionDistributed,
      'isCanceled': isCanceled,
      'isDeleted': isDeleted,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'bookingId': bookingId,
      'otp': otp,
      'listingPrice': listingPrice,
      'serviceDiscountPrice': serviceDiscountPrice,
      'priceAfterDiscount': priceAfterDiscount,
      'couponDiscountPrice': couponDiscountPrice,
      'serviceGSTPrice': serviceGSTPrice,
      'platformFeePrice': platformFeePrice,
      'assurityChargesPrice': assurityChargesPrice,
    };
  }

  CheckOutModel copyWith({
    String? user,
    String? service,
    String? serviceCustomer,
    String? provider,
    String? serviceMan,
    String? coupon,
    int? subtotal,
    int? serviceDiscount,
    int? couponDiscount,
    int? champaignDiscount,
    int? gst,
    int? platformFee,
    int? assurityfee,
    int? totalAmount,
    List<String>? paymentMethod,
    int? walletAmount,
    int? otherAmount,
    int? paidAmount,
    bool? isPartialPayment,
    int? remainingAmount,
    String? paymentStatus,
    String? orderStatus,
    String? notes,
    bool? termsCondition,
    bool? isVerified,
    bool? isAccepted,
    bool? isOtpVerified,
    bool? isCompleted,
    bool? commissionDistributed,
    bool? isCanceled,
    bool? isDeleted,
    String? id,
    String? createdAt,
    String? updatedAt,
    String? bookingId,
    String? otp,
    int? listingPrice,
    int? serviceDiscountPrice,
    int? priceAfterDiscount,
    int? couponDiscountPrice,
    int? serviceGSTPrice,
    int? platformFeePrice,
    int? assurityChargesPrice,
  }) {
    return CheckOutModel(
      user: user ?? this.user,
      service: service ?? this.service,
      serviceCustomer: serviceCustomer ?? this.serviceCustomer,
      provider: provider ?? this.provider,
      serviceMan: serviceMan ?? this.serviceMan,
      coupon: coupon ?? this.coupon,
      subtotal: subtotal ?? this.subtotal,
      serviceDiscount: serviceDiscount ?? this.serviceDiscount,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      champaignDiscount: champaignDiscount ?? this.champaignDiscount,
      gst: gst ?? this.gst,
      platformFee: platformFee ?? this.platformFee,
      assurityfee: assurityfee ?? this.assurityfee,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      walletAmount: walletAmount ?? this.walletAmount,
      otherAmount: otherAmount ?? this.otherAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      isPartialPayment: isPartialPayment ?? this.isPartialPayment,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      notes: notes ?? this.notes,
      termsCondition: termsCondition ?? this.termsCondition,
      isVerified: isVerified ?? this.isVerified,
      isAccepted: isAccepted ?? this.isAccepted,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      isCompleted: isCompleted ?? this.isCompleted,
      commissionDistributed: commissionDistributed ?? this.commissionDistributed,
      isCanceled: isCanceled ?? this.isCanceled,
      isDeleted: isDeleted ?? this.isDeleted,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookingId: bookingId ?? this.bookingId,
      otp: otp ?? this.otp,
      listingPrice: listingPrice ?? this.listingPrice,
      serviceDiscountPrice: serviceDiscountPrice ?? this.serviceDiscountPrice,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      couponDiscountPrice: couponDiscountPrice ?? this.couponDiscountPrice,
      serviceGSTPrice: serviceGSTPrice ?? this.serviceGSTPrice,
      platformFeePrice: platformFeePrice ?? this.platformFeePrice,
      assurityChargesPrice: assurityChargesPrice ?? this.assurityChargesPrice,
    );
  }
}
