import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/offer_repository.dart';
import 'offer_event.dart';
import 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OfferBloc() : super(OfferInitial()) {
    on<FetchOffersEvent>((event, emit) async {
      emit(OfferLoading());
      try {
        final offers = await OfferRepository.fetchOffers();
        emit(OfferLoaded(offers));
      } catch (e) {
        emit(OfferError(e.toString()));
      }
    });
  }
}
