class Review {
  final String id;
  final String userId;
  final String userEmail;
  final String providerId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.providerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};

    return Review(
      id: json['_id'] ?? '',
      userId: user['_id'] ?? '',
      userEmail: user['email'] ?? '',
      providerId: json['provider'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ProviderReviewResponse {
  final bool success;
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final List<Review> reviews;

  ProviderReviewResponse({
    required this.success,
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.reviews,
  });

  factory ProviderReviewResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> reviewJsonList = json['reviews'] ?? [];

    final reviewsList = reviewJsonList
        .map((reviewJson) => Review.fromJson(reviewJson))
        .toList();

    final Map<int, int> ratingDist = {};
    (json['ratingDistribution'] as Map<String, dynamic>?)?.forEach((key, value) {
      ratingDist[int.tryParse(key) ?? 0] = value;
    });

    return ProviderReviewResponse(
      success: json['success'] ?? false,
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingDistribution: ratingDist,
      reviews: reviewsList,
    );
  }
}
