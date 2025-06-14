class CheckoutModel {
  final String user;
  final String service;
  final String serviceCustomer;
  final String provider;
  final String coupon;
  final int subtotal;
  final int serviceDiscount;
  final int couponDiscount;
  final int champaignDiscount;
  final int vat;
  final int platformFee;
  final int garrantyFee;
  final int tax;
  final int totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String notes;

  CheckoutModel({
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
    required this.garrantyFee,
    required this.tax,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.notes,
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
      platformFee: json['platformFee']??0,
      garrantyFee: json['garrantyFee'] ??0,
      tax: json['tax'],
      totalAmount: json['totalAmount'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      orderStatus: json['orderStatus'],
      notes: json['notes'],
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
      "paymentStatus": paymentStatus,
      "orderStatus": orderStatus,
      "notes": notes,
    };
  }
}
