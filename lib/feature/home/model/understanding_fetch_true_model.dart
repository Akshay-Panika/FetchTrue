class UnderstandingFetchTrueModel {
  final bool success;
  final List<FetchTrueData> data;

  UnderstandingFetchTrueModel({
    required this.success,
    required this.data,
  });

  factory UnderstandingFetchTrueModel.fromJson(Map<String, dynamic> json) {
    return UnderstandingFetchTrueModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FetchTrueData.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class FetchTrueData {
  final String id;
  final String fullName;
  final String imageUrl;
  final String description;
  final String videoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FetchTrueData({
    required this.id,
    required this.fullName,
    required this.imageUrl,
    required this.description,
    required this.videoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory FetchTrueData.fromJson(Map<String, dynamic> json) {
    return FetchTrueData(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
