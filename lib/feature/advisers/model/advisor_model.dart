class AdvisorModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int phoneNumber;
  final String language;
  final List<String> tags;
  final String chat;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdvisorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.phoneNumber,
    required this.language,
    required this.tags,
    required this.chat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdvisorModel.fromJson(Map<String, dynamic> json) {
    return AdvisorModel(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      phoneNumber: json['phoneNumber'],
      language: json['language'],
      tags: List<String>.from(json['tags']),
      chat: json['chat'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
