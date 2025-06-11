class CouponModel {
  final String id;
  final String couponType;
  final String couponCode;
  final String discountType;
  final String discountTitle;
  final Category category;
  final Zone zone;
  final String discountAmountType;
  final int amount;
  final int maxDiscount;
  final int minPurchase;
  final DateTime startDate;
  final DateTime endDate;
  final int limitPerUser;
  final String discountCostBearer;
  final String couponAppliesTo;
  final bool isDeleted;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CouponModel({
    required this.id,
    required this.couponType,
    required this.couponCode,
    required this.discountType,
    required this.discountTitle,
    required this.category,
    required this.zone,
    required this.discountAmountType,
    required this.amount,
    required this.maxDiscount,
    required this.minPurchase,
    required this.startDate,
    required this.endDate,
    required this.limitPerUser,
    required this.discountCostBearer,
    required this.couponAppliesTo,
    required this.isDeleted,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'],
      couponType: json['couponType'],
      couponCode: json['couponCode'],
      discountType: json['discountType'],
      discountTitle: json['discountTitle'],
      category: Category.fromJson(json['category']),
      zone: Zone.fromJson(json['zone']),
      discountAmountType: json['discountAmountType'],
      amount: json['amount'],
      maxDiscount: json['maxDiscount'],
      minPurchase: json['minPurchase'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      limitPerUser: json['limitPerUser'],
      discountCostBearer: json['discountCostBearer'],
      couponAppliesTo: json['couponAppliesTo'],
      isDeleted: json['isDeleted'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'couponType': couponType,
      'couponCode': couponCode,
      'discountType': discountType,
      'discountTitle': discountTitle,
      'category': category.toJson(),
      'zone': zone.toJson(),
      'discountAmountType': discountAmountType,
      'amount': amount,
      'maxDiscount': maxDiscount,
      'minPurchase': minPurchase,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'limitPerUser': limitPerUser,
      'discountCostBearer': discountCostBearer,
      'couponAppliesTo': couponAppliesTo,
      'isDeleted': isDeleted,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Zone {
  final String id;
  final String name;

  Zone({required this.id, required this.name});

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}
