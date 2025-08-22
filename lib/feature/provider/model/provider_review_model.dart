class ProviderReviewModel {
  final bool success;
  final int totalReviews;
  final double averageRating;
  final Map<String, int> ratingDistribution;
  final List<Review> reviews;

  ProviderReviewModel({
    required this.success,
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.reviews,
  });

  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) {
    return ProviderReviewModel(
      success: json['success'] ?? false,
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingDistribution: Map<String, int>.from(json['ratingDistribution'] ?? {}),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Review {
  final String id;
  final String? user;
  final String provider;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    this.user,
    required this.provider,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      user: json['user'],
      provider: json['provider'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
