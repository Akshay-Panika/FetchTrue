// ----------------- Model -----------------
class YouTubeShortModel {
  final String id, title, channelTitle, thumbnailUrl;
  final String? duration, viewCount;

  YouTubeShortModel({
    required this.id,
    required this.title,
    required this.channelTitle,
    required this.thumbnailUrl,
    this.duration,
    this.viewCount,
  });

  factory YouTubeShortModel.fromJson(
      Map<String, dynamic> json, {
        Map<String, dynamic>? videoDetails,
      }) {
    return YouTubeShortModel(
      id: json['id']?['videoId'] ?? '',
      title: json['snippet']['title'],
      channelTitle: json['snippet']['channelTitle'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      duration: videoDetails?['contentDetails']?['duration'] ?? 'Unknown',
      viewCount: videoDetails?['statistics']?['viewCount'] ?? '0',
    );
  }
}