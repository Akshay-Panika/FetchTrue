class TrainingTutorialModel {
  final String name;
  final String imageUrl;
  final String description;
  final List<TutorialVideo> videoList;

  TrainingTutorialModel({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.videoList,
  });

  factory TrainingTutorialModel.fromJson(Map<String, dynamic> json) {
    return TrainingTutorialModel(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      videoList: (json['video'] as List)
          .map((v) => TutorialVideo.fromJson(v))
          .toList(),
    );
  }
}

class TutorialVideo {
  final String videoName;
  final String videoUrl;
  final String videoDescription;

  TutorialVideo({
    required this.videoName,
    required this.videoUrl,
    required this.videoDescription,
  });

  factory TutorialVideo.fromJson(Map<String, dynamic> json) {
    return TutorialVideo(
      videoName: json['videoName'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      videoDescription: json['videoDescription'] ?? '',
    );
  }
}
