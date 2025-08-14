import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/provider_review_service.dart';
import 'ProviderReviewEvent.dart';
import 'ProviderReviewState.dart';


class ProviderReviewBloc extends Bloc<ProviderReviewEvent, ProviderReviewState> {
  final ProviderReviewService reviewService;

  ProviderReviewBloc(this.reviewService) : super(ProviderReviewInitial()) {
    on<FetchProviderReviews>(_onFetchProviderReviews);
  }

  Future<void> _onFetchProviderReviews(
      FetchProviderReviews event,
      Emitter<ProviderReviewState> emit,
      ) async {
    emit(ProviderReviewLoading());
    try {
      final response = await reviewService.fetchReviews(event.providerId);
      if (response != null && response.success) {
        emit(ProviderReviewLoaded(response));
      } else {
        emit(ProviderReviewError("Failed to load reviews"));
      }
    } catch (e) {
      emit(ProviderReviewError(e.toString()));
    }
  }
}
