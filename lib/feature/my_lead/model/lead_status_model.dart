// lead_status_model.dart
class LeadStatusModel {
  final String id;
  final String checkout;
  final bool? isAdminApproved;
  final List<LeadStatusItem> leads;

  LeadStatusModel({
    required this.id,
    required this.checkout,
    required this.isAdminApproved,
    required this.leads,
  });

  factory LeadStatusModel.fromJson(Map<String, dynamic> json) {
    return LeadStatusModel(
      id: json['_id'],
      checkout: json['checkout'],
      isAdminApproved: json['isAdminApproved'],
      leads: (json['leads'] as List)
          .map((e) => LeadStatusItem.fromJson(e))
          .toList(),
    );
  }
}

class LeadStatusItem {
  final String statusType;
  final String description;
  final String zoomLink;
  final String? paymentLink;
  final String? paymentType;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeadStatusItem({
    required this.statusType,
    required this.description,
    required this.zoomLink,
    this.paymentLink,
    this.paymentType,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeadStatusItem.fromJson(Map<String, dynamic> json) {
    return LeadStatusItem(
      statusType: json['statusType'] ?? '',
      description: json['description'] ?? '',
      zoomLink: json['zoomLink'] ?? '',
      paymentLink: json['paymentLink'],
      paymentType: json['paymentType'],
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

