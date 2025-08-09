abstract class ProviderByIdEvent {}

class GetProviderByIdEvent extends ProviderByIdEvent {
  final String providerId;

  GetProviderByIdEvent(this.providerId);
}