// class CouponModel {
//   final String id;
//   final String couponCode;
//   final String discountTitle;
//   final String discountType;
//   final String discountAmountType;
//   final String couponType;
//   final String couponAppliesTo;
//   final String discountCostBearer;
//   final String? categoryName;
//   final String? serviceName;
//   final String? zoneName;
//   final int amount;
//   final int? maxDiscount;
//   final int minPurchase;
//   final int limitPerUser;
//   final bool isActive;
//
//   CouponModel({
//     required this.id,
//     required this.couponCode,
//     required this.discountTitle,
//     required this.discountType,
//     required this.discountAmountType,
//     required this.couponType,
//     required this.couponAppliesTo,
//     required this.discountCostBearer,
//     this.categoryName,
//     this.serviceName,
//     this.zoneName,
//     required this.amount,
//     this.maxDiscount,
//     required this.minPurchase,
//     required this.limitPerUser,
//     required this.isActive,
//   });
//
//   factory CouponModel.fromJson(Map<String, dynamic> json) {
//     return CouponModel(
//       id: json['_id'] ?? '',
//       couponCode: json['couponCode'] ?? '',
//       discountTitle: json['discountTitle'] ?? '',
//       discountType: json['discountType'] ?? '',
//       discountAmountType: json['discountAmountType'] ?? '',
//       couponType: json['couponType'] ?? '',
//       couponAppliesTo: json['couponAppliesTo'] ?? '',
//       discountCostBearer: json['discountCostBearer'] ?? '',
//       categoryName: json['category']?['name'],
//       serviceName: json['service']?['serviceName'],
//       zoneName: json['zone']?['name'],
//       amount: json['amount'] ?? 0,
//       maxDiscount: json['maxDiscount'],
//       minPurchase: json['minPurchase'] ?? 0,
//       limitPerUser: json['limitPerUser'] ?? 0,
//       isActive: json['isActive'] ?? false,
//     );
//   }
// }


class CouponModel {
  final String id;
  final String couponCode;
  final String discountTitle;
  final String discountType;
  final String discountAmountType;
  final String couponType;
  final String couponAppliesTo;
  final String discountCostBearer;
  final Category? category;
  final Zone? zone;
  final String? customerId; // customerWise coupon के लिए
  final int amount;
  final int? maxDiscount;
  final int minPurchase;
  final int limitPerUser;
  final bool isDeleted;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v; // __v field

  CouponModel({
    required this.id,
    required this.couponCode,
    required this.discountTitle,
    required this.discountType,
    required this.discountAmountType,
    required this.couponType,
    required this.couponAppliesTo,
    required this.discountCostBearer,
    this.category,
    this.zone,
    this.customerId,
    required this.amount,
    this.maxDiscount,
    required this.minPurchase,
    required this.limitPerUser,
    required this.isDeleted,
    required this.isActive,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
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
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      zone: json['zone'] != null ? Zone.fromJson(json['zone']) : null,
      customerId: json['customer'],
      amount: (json['amount'] ?? 0).toInt(),
      maxDiscount: json['maxDiscount'] != null ? (json['maxDiscount'] as num).toInt() : null,
      minPurchase: (json['minPurchase'] ?? 0).toInt(),
      limitPerUser: (json['limitPerUser'] ?? 0).toInt(),
      isDeleted: json['isDeleted'] ?? false,
      isActive: json['isActive'] ?? false,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Zone {
  final String id;
  final String name;

  Zone({required this.id, required this.name});

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}


