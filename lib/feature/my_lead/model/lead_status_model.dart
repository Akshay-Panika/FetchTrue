class LeadStatusModel {
  final String id;
  final String statusType;
  final String description;
  final List<String> zoomLinks;
  final List<String> paymentLinks;
  final String paymentType;
  final String document;
  final Checkout checkout;

  LeadStatusModel({
    required this.id,
    required this.statusType,
    required this.description,
    required this.zoomLinks,
    required this.paymentLinks,
    required this.paymentType,
    required this.document,
    required this.checkout,
  });

  factory LeadStatusModel.fromJson(Map<String, dynamic> json) {
    return LeadStatusModel(
      id: json['_id'],
      statusType: json['statusType'],
      description: json['description'],
      zoomLinks: json['zoomLink'].split(','),
      paymentLinks: json['paymentLink'].split(','),
      paymentType: json['paymentType'],
      document: json['document'],
      checkout: Checkout.fromJson(json['checkout']),
    );
  }
}

class Checkout {
  final String bookingId;
  final int totalAmount;
  final String paymentStatus;

  Checkout({
    required this.bookingId,
    required this.totalAmount,
    required this.paymentStatus,
  });

  factory Checkout.fromJson(Map<String, dynamic> json) {
    return Checkout(
      bookingId: json['bookingId'],
      totalAmount: json['totalAmount'],
      paymentStatus: json['paymentStatus'],
    );
  }
}
