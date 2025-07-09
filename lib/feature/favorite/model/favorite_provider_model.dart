class FavoriteProviderModel {
  final List<String> favoriteProvider;

  FavoriteProviderModel({required this.favoriteProvider});

  factory FavoriteProviderModel.fromJson(Map<String, dynamic> json) {
    return FavoriteProviderModel(
      favoriteProvider: List<String>.from(json['data']['favoriteProviders']),
    );
  }
}
