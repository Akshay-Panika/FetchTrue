// import 'package:equatable/equatable.dart';
//
// abstract class UserReferralEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
//
// class FetchUserByReferralCode extends UserReferralEvent {
//   final String referralCode;
//
//   FetchUserByReferralCode(this.referralCode);
//
//   @override
//   List<Object?> get props => [referralCode];
// }


import 'package:equatable/equatable.dart';

abstract class UserReferralEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserByReferralCode extends UserReferralEvent {
  final String referralCode;

  FetchUserByReferralCode(this.referralCode);

  @override
  List<Object?> get props => [referralCode];
}

class ConfirmReferralCodeEvent extends UserReferralEvent {
  final String userId;
  final String referralCode;

  ConfirmReferralCodeEvent({required this.userId, required this.referralCode});

  @override
  List<Object?> get props => [userId, referralCode];
}
