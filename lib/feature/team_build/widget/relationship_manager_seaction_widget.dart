
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/custom_snackbar.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/bloc/user_by_id/user_by_id_bloc.dart';
import '../../profile/bloc/user_by_id/user_by_id_event.dart';
import '../../profile/bloc/user_by_id/user_by_id_state.dart';
import '../../profile/model/user_model.dart';
import '../bloc/user_referral/user_referral_bloc.dart';
import '../bloc/user_referral/user_referral_event.dart';
import '../bloc/user_referral/user_referral_state.dart';

class RelationshipManagerSectionWidget extends StatelessWidget {
  const RelationshipManagerSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _referralController = TextEditingController();

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return CircularProgressIndicator();
        }
        UserModel? user;
        if (state is UserLoaded) {
          user = state.user;

          if(user.referredBy != null)
            context.read<UserByIdBloc>().add(FetchUserById(user.referredBy!));

          return  Column(
            children: [

              Column(
                children: [

                  if(user.referredBy == null)
                    BlocConsumer<UserReferralBloc, UserReferralState>(
                      listener: (context, state) {
                        if (state is UserReferralConfirmed) {
                          showCustomToast(state.message);
                          _referralController.clear();
                          context.read<UserReferralBloc>().emit(UserReferralInitial());
                        } else if (state is UserReferralError) {
                          showCustomToast(state.message);
                        }
                      },
                      builder: (context, state) {
                        if (state is UserReferralInitial) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _referralController,
                                    decoration: const InputDecoration(
                                      hintText: 'Referral Code...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    final code = _referralController.text.trim();
                                    if (code.isNotEmpty) {
                                      context.read<UserReferralBloc>().add(FetchUserByReferralCode(code));
                                    }
                                  },
                                  child: const Text("Verify"),
                                ),
                              ],
                            ),
                          );
                        } else if (state is UserReferralLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is UserReferralLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Name: ${state.user.fullName}'),
                              Text('Email: ${state.user.email}'),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<UserReferralBloc>().emit(UserReferralInitial());
                                      _referralController.clear();
                                    },
                                    child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      final referralCode = _referralController.text.trim();

                                      if (user!.id.isNotEmpty && referralCode.isNotEmpty) {
                                        context.read<UserReferralBloc>().add(ConfirmReferralCodeEvent(
                                          userId: user.id,
                                          referralCode: referralCode,
                                        ),);
                                        context.read<UserByIdBloc>().add(FetchUserById(user.referredBy!));

                                      }
                                    },
                                    child: const Text('Confirm', style: TextStyle(color: Colors.green)),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (state is UserReferralError) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Wrong Referral Code',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),

                  if(user.referredBy != null)
                    BlocBuilder<UserByIdBloc, UserByIdState>(
                      builder: (context, state) {
                        if (state is UserByIdLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is UserByIdLoaded) {
                          final user = state.user;
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${user.fullName}"),
                                Text("Email: ${user.email}"),
                              ],
                            ),
                          );
                        } else if (state is UserByIdError) {
                          return Center(child: Text("Error: ${state.message}"));
                        }
                        return const SizedBox();
                      },
                    ),
                ],
              )
            ],
          );
        }
        if(state is UserError){
          print('Error : ${state.massage}');
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );;
  }
}
