class BannerModel {
  final String id;
  final String file;
  final String page;

  BannerModel({
    required this.id,
    required this.file,
    required this.page,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'],
      file: json['file'],
      page: json['page'],
    );
  }
}
