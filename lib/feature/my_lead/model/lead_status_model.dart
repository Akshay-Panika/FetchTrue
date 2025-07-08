class LeadStatusModel {
  final String id;
  final int amount;
  final bool? isAdminApproved;
  final List<LeadData> leads;
  final CheckoutData? checkout;

  LeadStatusModel({
    required this.id,
    required this.amount,
    this.isAdminApproved,
    required this.leads,
    this.checkout,
  });

  factory LeadStatusModel.fromJson(Map<String, dynamic> json) {
    return LeadStatusModel(
      id: json['_id'],
      amount: json['amount'],
      isAdminApproved: json['isAdminApproved'],
      leads: (json['leads'] as List<dynamic>)
          .map((e) => LeadData.fromJson(e))
          .toList(),
      checkout: json['checkout'] != null
          ? CheckoutData.fromJson(json['checkout'])
          : null,
    );
  }
}

class LeadData {
  final String id;
  final String statusType;
  final String? description;
  final String? zoomLink;
  final DateTime createdAt;

  LeadData({
    required this.id,
    required this.statusType,
    this.description,
    this.zoomLink,
    required this.createdAt,
  });

  factory LeadData.fromJson(Map<String, dynamic> json) {
    return LeadData(
      id: json['_id'],
      statusType: json['statusType'] ?? '',
      description: json['description'],
      zoomLink: json['zoomLink'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CheckoutData {
  final String id;

  CheckoutData({required this.id});

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      id: json['_id'],
    );
  }
}
