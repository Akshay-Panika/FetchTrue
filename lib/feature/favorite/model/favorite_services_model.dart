class FavoriteServicesModel {
  final List<String> favoriteServices;

  FavoriteServicesModel({required this.favoriteServices});

  factory FavoriteServicesModel.fromJson(Map<String, dynamic> json) {
    return FavoriteServicesModel(
      favoriteServices: List<String>.from(json['data']['favoriteServices']),
    );
  }
}
