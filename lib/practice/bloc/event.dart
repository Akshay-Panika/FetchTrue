import '../model.dart';

abstract class UEvent {}

class ULoad extends UEvent {
  final String userId;
  ULoad(this.userId);
}

class UUpdate extends UEvent {
  final UModel updatedUser;
  UUpdate(this.updatedUser);
}
