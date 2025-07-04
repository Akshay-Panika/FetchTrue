class CheckoutModel {
  final String user;
  final String service;
  final String serviceCustomer;
  final String? provider;
  final String? coupon;
  final int subtotal;
  final int serviceDiscount;
  final int couponDiscount;
  final int champaignDiscount;
  final int vat;
  final int platformFee;
  final int garrantyFee;
  final int tax;
  final int totalAmount;
  final List<String> paymentMethod;
  final int walletAmount;
  final int paidByOtherMethodAmount;
  final int partialPaymentNow;
  final int partialPaymentLater;
  final String remainingPaymentStatus;
  final String paymentStatus;
  final String orderStatus;
  final String notes;
  final bool termsCondition;

  CheckoutModel({
    required this.user,
    required this.service,
    required this.serviceCustomer,
    this.provider,
    this.coupon,
    required this.subtotal,
    required this.serviceDiscount,
    required this.couponDiscount,
    required this.champaignDiscount,
    required this.vat,
    required this.platformFee,
    required this.garrantyFee,
    required this.tax,
    required this.totalAmount,
    required this.paymentMethod,
    required this.walletAmount,
    required this.paidByOtherMethodAmount,
    required this.partialPaymentNow,
    required this.partialPaymentLater,
    required this.remainingPaymentStatus,
    required this.paymentStatus,
    required this.orderStatus,
    required this.notes,
    required this.termsCondition,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
      user: json['user'],
      service: json['service'],
      serviceCustomer: json['serviceCustomer'],
      provider: json['provider'],
      coupon: json['coupon'],
      subtotal: json['subtotal'],
      serviceDiscount: json['serviceDiscount'],
      couponDiscount: json['couponDiscount'],
      champaignDiscount: json['champaignDiscount'],
      vat: json['vat'],
      platformFee: json['platformFee'] ?? 0,
      garrantyFee: json['garrantyFee'] ?? 0,
      tax: json['tax'],
      totalAmount: json['totalAmount'],
      paymentMethod: List<String>.from(json['paymentMethod'] ?? []),
      walletAmount: json['walletAmount'] ?? 0,
      paidByOtherMethodAmount: json['paidByOtherMethodAmount'] ?? 0,
      partialPaymentNow: json['partialPaymentNow'] ?? 0,
      partialPaymentLater: json['partialPaymentLater'] ?? 0,
      remainingPaymentStatus: json['remainingPaymentStatus'] ?? 'pending',
      paymentStatus: json['paymentStatus'],
      orderStatus: json['orderStatus'],
      notes: json['notes'],
      termsCondition: json['termsCondition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "service": service,
      "serviceCustomer": serviceCustomer,
      "provider": provider,
      "coupon": coupon,
      "subtotal": subtotal,
      "serviceDiscount": serviceDiscount,
      "couponDiscount": couponDiscount,
      "champaignDiscount": champaignDiscount,
      "vat": vat,
      "platformFee": platformFee,
      "garrantyFee": garrantyFee,
      "tax": tax,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "walletAmount": walletAmount,
      "paidByOtherMethodAmount": paidByOtherMethodAmount,
      "partialPaymentNow": partialPaymentNow,
      "partialPaymentLater": partialPaymentLater,
      "remainingPaymentStatus": remainingPaymentStatus,
      "paymentStatus": paymentStatus,
      "orderStatus": orderStatus,
      "notes": notes,
      "termsCondition": termsCondition,
    };
  }

  CheckoutModel copyWith({
    String? user,
    String? service,
    String? serviceCustomer,
    String? provider,
    String? coupon,
    int? subtotal,
    int? serviceDiscount,
    int? couponDiscount,
    int? champaignDiscount,
    int? vat,
    int? platformFee,
    int? garrantyFee,
    int? tax,
    int? totalAmount,
    List<String>? paymentMethod,
    int? walletAmount,
    int? paidByOtherMethodAmount,
    int? partialPaymentNow,
    int? partialPaymentLater,
    String? remainingPaymentStatus,
    String? paymentStatus,
    String? orderStatus,
    String? notes,
    bool? termsCondition,
  }) {
    return CheckoutModel(
      user: user ?? this.user,
      service: service ?? this.service,
      serviceCustomer: serviceCustomer ?? this.serviceCustomer,
      provider: provider ?? this.provider,
      coupon: coupon ?? this.coupon,
      subtotal: subtotal ?? this.subtotal,
      serviceDiscount: serviceDiscount ?? this.serviceDiscount,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      champaignDiscount: champaignDiscount ?? this.champaignDiscount,
      vat: vat ?? this.vat,
      platformFee: platformFee ?? this.platformFee,
      garrantyFee: garrantyFee ?? this.garrantyFee,
      tax: tax ?? this.tax,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      walletAmount: walletAmount ?? this.walletAmount,
      paidByOtherMethodAmount: paidByOtherMethodAmount ?? this.paidByOtherMethodAmount,
      partialPaymentNow: partialPaymentNow ?? this.partialPaymentNow,
      partialPaymentLater: partialPaymentLater ?? this.partialPaymentLater,
      remainingPaymentStatus: remainingPaymentStatus ?? this.remainingPaymentStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      notes: notes ?? this.notes,
      termsCondition: termsCondition ?? this.termsCondition,
    );
  }
}
