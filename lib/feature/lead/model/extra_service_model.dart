class ExtraServiceModel {
  final String serviceName;
  final double price;
  final double discount;
  final double total;
  final String commission;
  final bool isLeadApproved;

  ExtraServiceModel({
    required this.serviceName,
    required this.price,
    required this.discount,
    required this.total,
    required this.commission,
    required this.isLeadApproved,
  });

  factory ExtraServiceModel.fromJson(Map<String, dynamic> json) {
    return ExtraServiceModel(
      serviceName: json['serviceName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      commission: json['commission'] ?? '',
      isLeadApproved: json['isLeadApproved'] ?? false,
    );
  }
}
