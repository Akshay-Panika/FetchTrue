class UpcomingLeadCommissionModel {
  final bool success;
  final CommissionData? data;

  UpcomingLeadCommissionModel({
    required this.success,
    this.data,
  });

  factory UpcomingLeadCommissionModel.fromJson(Map<String, dynamic> json) {
    return UpcomingLeadCommissionModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? CommissionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class CommissionData {
  final String id;
  final String? leadId;
  final String checkoutId;
  final int share1;
  final int share2;
  final int share3;
  final int adminCommission;
  final int providerShare;
  final int extraShare1;
  final int extraShare2;
  final int extraShare3;
  final int extraAdminCommission;
  final int extraProviderShare;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CommissionData({
    required this.id,
    this.leadId,
    required this.checkoutId,
    required this.share1,
    required this.share2,
    required this.share3,
    required this.adminCommission,
    required this.providerShare,
    required this.extraShare1,
    required this.extraShare2,
    required this.extraShare3,
    required this.extraAdminCommission,
    required this.extraProviderShare,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// helper function to safely cast to int
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory CommissionData.fromJson(Map<String, dynamic> json) {
    return CommissionData(
      id: json['_id'] ?? '',
      leadId: json['leadId'],
      checkoutId: json['checkoutId'] ?? '',
      share1: _toInt(json['share_1']),
      share2: _toInt(json['share_2']),
      share3: _toInt(json['share_3']),
      adminCommission: _toInt(json['admin_commission']),
      providerShare: _toInt(json['provider_share']),
      extraShare1: _toInt(json['extra_share_1']),
      extraShare2: _toInt(json['extra_share_2']),
      extraShare3: _toInt(json['extra_share_3']),
      extraAdminCommission: _toInt(json['extra_admin_commission']),
      extraProviderShare: _toInt(json['extra_provider_share']),
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      v: _toInt(json['__v']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'leadId': leadId,
      'checkoutId': checkoutId,
      'share_1': share1,
      'share_2': share2,
      'share_3': share3,
      'admin_commission': adminCommission,
      'provider_share': providerShare,
      'extra_share_1': extraShare1,
      'extra_share_2': extraShare2,
      'extra_share_3': extraShare3,
      'extra_admin_commission': extraAdminCommission,
      'extra_provider_share': extraProviderShare,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
