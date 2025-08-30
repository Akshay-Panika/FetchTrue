import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/bloc/user_by_id/user_by_id_bloc.dart';
import '../../profile/bloc/user_by_id/user_by_id_event.dart';
import '../../profile/bloc/user_by_id/user_by_id_state.dart';
import '../bloc/user_confirm_referral/user_confirm_referral_bloc.dart';
import '../bloc/user_confirm_referral/user_confirm_referral_event.dart';
import '../bloc/user_confirm_referral/user_confirm_referral_state.dart';
import '../bloc/user_referral/user_referral_bloc.dart';
import '../bloc/user_referral/user_referral_event.dart';
import '../bloc/user_referral/user_referral_state.dart';

class RelationshipManagerSection extends StatelessWidget {
  const RelationshipManagerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _referralController = TextEditingController();

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserLoaded) {
          final user = state.user;

          if(user.referredBy != null){
            context.read<UserByIdBloc>().add(FetchUserById(state.user.referredBy!));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              10.height,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: const Text('Relationship Manager'),
              ),

              if(user.referredBy == null)
              Column(
                children: [
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _referralController,
                            decoration: const InputDecoration(
                              hintText: 'Referral Code...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        /// Referral Bloc Section
                        BlocConsumer<UserReferralBloc, UserReferralState>(
                          listener: (context, state) {
                            if (state is UserReferralError) {
                              showCustomToast('Wrong referral code  #${_referralController.text}');
                            }
                          },
                          builder: (context, state) {
                            if (state is UserReferralInitial) {
                              return TextButton(
                                onPressed: () {
                                  final code = _referralController.text.trim();
                                  if (code.isNotEmpty) {
                                    context.read<UserReferralBloc>().add(
                                      FetchUserByReferralCode(code),
                                    );
                                  }
                                },
                                child: Text(
                                  "Verify",
                                  style: TextStyle(color: CustomColor.appColor),
                                ),
                              );
                            } else if (state is UserReferralLoading) {
                              return const SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: CircularProgressIndicator(strokeWidth: 4),
                                ),
                              );
                            } else if (state is UserReferralLoaded) {
                              return const Text(
                                'Verified',
                                style: TextStyle(color: Colors.green),
                              );
                            } else if (state is UserReferralError) {
                              return const Text(
                                'Wrong',
                                style: TextStyle(color: Colors.red),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        10.width,
                      ],
                    ),
                  ),

                  /// Verified User Details + Actions
                  BlocBuilder<UserReferralBloc, UserReferralState>(
                    builder: (context, state) {
                      if (state is UserReferralLoaded) {
                        return CustomContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${state.user.fullName}'),
                              Text('Email: ${state.user.email}'),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<UserReferralBloc>().emit(UserReferralInitial());
                                      _referralController.clear();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  BlocConsumer<UserConfirmReferralBloc, UserConfirmReferralState>(
                                    listener: (context, confirmState) {
                                      if (confirmState is UserConfirmReferralError) {
                                        showCustomToast('Please change referral code!');
                                      }
                                      if (confirmState is UserConfirmReferralLoaded) {
                                        showCustomToast('Referral confirmed ✅');

                                        /// Re-fetch fresh user details
                                        context.read<UserBloc>().add(GetUserById(user.id));

                                        /// ReferralCode textfield clear
                                        _referralController.clear();

                                        /// Reset referral verification state (taaki UI dobara build ho)
                                        context.read<UserReferralBloc>().emit(UserReferralInitial());
                                      }
                                    },
                                    builder: (context, confirmState) {
                                      if (confirmState is UserConfirmReferralLoading) {
                                        return const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        );
                                      } else if (confirmState is UserConfirmReferralLoaded) {
                                        return const Text("Confirmed", style: TextStyle(color: Colors.green));
                                      }
                                      return TextButton(
                                        onPressed: () {
                                          final referralCode = _referralController.text.trim();
                                          if (user.id.isNotEmpty && referralCode.isNotEmpty) {
                                            context.read<UserConfirmReferralBloc>().add(
                                              ConfirmReferralCodeEvent(
                                                userId: user.id,
                                                referralCode: referralCode,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else if (state is UserReferralError) {
                        return CustomContainer(
                          color: Colors.white,
                          border: true,
                          child: ListTile(
                            title: Text(
                              'Alert!',
                              style: textStyle18(context, color: Colors.red),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  'Wrong Referral Code',
                                  style: textStyle14(context),
                                ),
                                10.width,
                                Text(
                                  '#${_referralController.text}',
                                  style: textStyle14(context, color: Colors.red),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                context.read<UserReferralBloc>().emit(UserReferralInitial());
                                _referralController.clear();
                              },
                              icon: const Icon(CupertinoIcons.refresh),
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),


              if(user.referredBy != null)
                BlocBuilder<UserByIdBloc, UserByIdState>(
                  builder: (context, state) {
                    if (state is UserByIdLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UserByIdLoaded) {
                      final user = state.user;
                      return CustomContainer(
                       width: double.infinity,
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
          );
        }

        if (state is UserError) {
          debugPrint('Error : ${state.massage}');
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}


