class AppliedCoupon {
  final String couponId;
  final String couponCode;
  final String couponTitle;
  final String discountType;
  final double amount;
  final int usedCount;
  final int limitPerUser;
  final DateTime startDate;
  final DateTime endDate;

  AppliedCoupon({
    required this.couponId,
    required this.couponCode,
    required this.couponTitle,
    required this.discountType,
    required this.amount,
    required this.usedCount,
    required this.limitPerUser,
    required this.startDate,
    required this.endDate,
  });

  factory AppliedCoupon.fromJson(Map<String, dynamic> json) {
    return AppliedCoupon(
      couponId: json['couponId'] ?? '',
      couponCode: json['couponCode'] ?? '',
      couponTitle: json['couponTitle'] ?? '',
      discountType: json['discountType'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      usedCount: json['usedCount'] ?? 0,
      limitPerUser: json['limitPerUser'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

class AppliedCouponResponse {
  final bool success;
  final List<AppliedCoupon> data;

  AppliedCouponResponse({
    required this.success,
    required this.data,
  });

  factory AppliedCouponResponse.fromJson(Map<String, dynamic> json) {
    return AppliedCouponResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List)
          .map((e) => AppliedCoupon.fromJson(e))
          .toList(),
    );
  }
}
