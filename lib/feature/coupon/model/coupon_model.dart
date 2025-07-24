class CouponModel {
  final String id;
  final String couponCode;
  final String discountTitle;
  final String discountType;
  final String discountAmountType;
  final String couponType;
  final String couponAppliesTo;
  final String discountCostBearer;
  final String? categoryName;
  final String? serviceName;
  final String? zoneName;
  final int amount;
  final int? maxDiscount;
  final int minPurchase;
  final int limitPerUser;
  final bool isActive;

  CouponModel({
    required this.id,
    required this.couponCode,
    required this.discountTitle,
    required this.discountType,
    required this.discountAmountType,
    required this.couponType,
    required this.couponAppliesTo,
    required this.discountCostBearer,
    this.categoryName,
    this.serviceName,
    this.zoneName,
    required this.amount,
    this.maxDiscount,
    required this.minPurchase,
    required this.limitPerUser,
    required this.isActive,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'] ?? '',
      couponCode: json['couponCode'] ?? '',
      discountTitle: json['discountTitle'] ?? '',
      discountType: json['discountType'] ?? '',
      discountAmountType: json['discountAmountType'] ?? '',
      couponType: json['couponType'] ?? '',
      couponAppliesTo: json['couponAppliesTo'] ?? '',
      discountCostBearer: json['discountCostBearer'] ?? '',
      categoryName: json['category']?['name'],
      serviceName: json['service']?['serviceName'],
      zoneName: json['zone']?['name'],
      amount: json['amount'] ?? 0,
      maxDiscount: json['maxDiscount'],
      minPurchase: json['minPurchase'] ?? 0,
      limitPerUser: json['limitPerUser'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }
}
