abstract class WalletEvent {}

class FetchWallet extends WalletEvent {
  final String userId;
  FetchWallet(this.userId);
}
