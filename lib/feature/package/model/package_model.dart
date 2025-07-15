class PackageModel {
  final String id;
  final int price;
  final int discount;
  final int discountedPrice;
  final int deposit;
  final int grandtotal;
  final Map<String, String> description;

  PackageModel({
    required this.id,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.deposit,
    required this.description,
    required this.grandtotal,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id'],
      price: json['price'],
      discount: json['discount'],
      discountedPrice: json['discountedPrice'],
      deposit: json['deposit'],
      grandtotal: json['grandtotal'],
      description: Map<String, String>.from(json['description']),
    );
  }
}
