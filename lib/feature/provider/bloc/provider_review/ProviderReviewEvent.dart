abstract class ProviderReviewEvent {}

class FetchProviderReviews extends ProviderReviewEvent {
  final String providerId;
  FetchProviderReviews(this.providerId);
}
