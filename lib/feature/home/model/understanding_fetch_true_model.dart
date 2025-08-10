class UnderstandingFetchTrueModel {
  final bool success;
  final List<FetchTrueData> data;

  UnderstandingFetchTrueModel({required this.success, required this.data});

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
  final List<VideoItem> videos;
  final DateTime createdAt;

  FetchTrueData({
    required this.id,
    required this.fullName,
    required this.videos,
    required this.createdAt,
  });

  factory FetchTrueData.fromJson(Map<String, dynamic> json) {
    return FetchTrueData(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => VideoItem.fromJson(e))
          .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class VideoItem {
  final String fileName;
  final String filePath;

  VideoItem({required this.fileName, required this.filePath});

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
    );
  }
}
