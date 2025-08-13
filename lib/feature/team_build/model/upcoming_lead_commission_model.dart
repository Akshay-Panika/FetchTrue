class UpcomingLeadCommissionModel {
  final bool success;
  final CommissionData data;

  UpcomingLeadCommissionModel({required this.success, required this.data});

  factory UpcomingLeadCommissionModel.fromJson(Map<String, dynamic> json) {
    return UpcomingLeadCommissionModel(
      success: json['success'] ?? false,
      data: CommissionData.fromJson(json['data'] ?? {}),
    );
  }
}

class CommissionData {
  final String id;
  final String leadId;
  final String checkoutId;
  final double share1;
  final double share2;
  final double share3;
  final double adminCommission;
  final double providerShare;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommissionData({
    required this.id,
    required this.leadId,
    required this.checkoutId,
    required this.share1,
    required this.share2,
    required this.share3,
    required this.adminCommission,
    required this.providerShare,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommissionData.fromJson(Map<String, dynamic> json) {
    return CommissionData(
      id: json['_id'] ?? '',
      leadId: json['leadId'] ?? '',
      checkoutId: json['checkoutId'] ?? '',
      share1: (json['share_1'] ?? 0).toDouble(),
      share2: (json['share_2'] ?? 0).toDouble(),
      share3: (json['share_3'] ?? 0).toDouble(),
      adminCommission: (json['admin_commission'] ?? 0).toDouble(),
      providerShare: (json['provider_share'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
