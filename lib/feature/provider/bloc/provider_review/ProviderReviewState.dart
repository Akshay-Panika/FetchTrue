import '../../model/provider_review_model.dart';

abstract class ProviderReviewState {}

class ProviderReviewInitial extends ProviderReviewState {}

class ProviderReviewLoading extends ProviderReviewState {}

class ProviderReviewLoaded extends ProviderReviewState {
  final ProviderReviewResponse reviewResponse;
  ProviderReviewLoaded(this.reviewResponse);
}

class ProviderReviewError extends ProviderReviewState {
  final String message;
  ProviderReviewError(this.message);
}
