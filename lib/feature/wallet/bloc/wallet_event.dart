// wallet_event.dart
abstract class WalletEvent {}

class FetchWalletByUser extends WalletEvent {
  final String userId;
  FetchWalletByUser(this.userId);
}
