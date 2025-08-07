import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/team_build/widget/relationship_manager_card_widget.dart';
import 'package:fetchtrue/feature/team_build/widget/team_gp_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_toggle_taps.dart';
import '../../../helper/Contact_helper.dart';
import '../../profile/bloc/user_bloc/user_event.dart';
import '../../profile/model/user_model.dart';
import '../repository/fetch_referred_user_service.dart';
import '../repository/referral_service.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_state.dart';
import '../model/referred_user_model.dart';
import '../repository/referred_user_service_confirm.dart';
import 'non_gp_widget.dart';

class MyTeamSectionWidget extends StatefulWidget {
  const MyTeamSectionWidget({super.key});

  @override
  State<MyTeamSectionWidget> createState() => _MyTeamSectionWidgetState();
}

class _MyTeamSectionWidgetState extends State<MyTeamSectionWidget> {
  final TextEditingController referralController = TextEditingController();
  final ReferralServiceConfirm _referralServiceConfirm = ReferralServiceConfirm();
  ReferredUser? referredUser;
  bool isVerifying = false;
  bool isConfirming = false;

  int _tapIndex = 0;

  @override
  void dispose() {
    referralController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      context.read<UserBloc>().add(FetchUserById(userState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserLoaded) {
          final users = state.user;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [

                      /// Relationship Manager card
                      FutureBuilder<UserModel?>(
                        future: users.referredBy != null
                            ? fetchReferredUser(users.referredBy!)
                            : Future.value(null),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return const Text("Something went wrong.");
                          }

                          if (snapshot.hasData && snapshot.data != null) {
                            final user = snapshot.data!;

                            return CustomContainer(
                              border: true,
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Relationship Manager', style: textStyle14(context)),
                                  10.height,
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage(CustomImage.nullImage),
                                        radius: 30,
                                        backgroundColor: Colors.grey[100],
                                      ),
                                      15.width,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Name : ${user.fullName}'),
                                          Text('Mobile : ${user.mobileNumber}'),
                                          Text('Email : ${user.email}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: 0.4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ' Self Follow Up',
                                        style: textStyle16(
                                          context,
                                          fontWeight: FontWeight.w400,
                                          color: CustomColor.appColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ContactHelper.call(user.mobileNumber);
                                            },
                                            child: Image.asset(
                                              CustomIcon.phoneIcon,
                                              height: 25,
                                              color: CustomColor.appColor,
                                            ),
                                          ),
                                          50.width,
                                          InkWell(
                                            onTap: () {
                                              ContactHelper.whatsapp(user.mobileNumber, 'Hello, ${user.fullName}');
                                            },
                                            child: Image.asset(CustomIcon.whatsappIcon, height: 25),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }

                          return SizedBox.shrink();
                        },
                      ),


                      if (users.referredBy == null && referredUser == null)
                        DottedBorder(
                          color: Colors.grey,
                          dashPattern: [10, 5],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          borderPadding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              children: [
                                const SizedBox(width: 25),
                                Expanded(
                                  child: TextField(
                                    controller: referralController,
                                    decoration: const InputDecoration(
                                      hintText: 'Referral Code Here...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: CustomButton(
                                    buttonColor: referralController.text.isEmpty
                                        ? Colors.grey
                                        : CustomColor.appColor,
                                    isLoading: isVerifying,
                                    label: 'Verify',
                                    onPressed: () async {
                                      final code = referralController.text.trim();
                                      if (code.isEmpty) {
                                        showCustomToast('Please enter a referral code.');
                                        return;
                                      }

                                      setState(() => isVerifying = true);

                                      final result =
                                      await ReferralService.verifyReferralCode(code);

                                      setState(() {
                                        isVerifying = false;
                                        referredUser = result;
                                      });

                                      if (result != null) {
                                        showCustomToast("Referral Code Verified!");
                                      } else {
                                        showCustomToast("Invalid Referral Code");
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10)
                              ],
                            ),
                          ),
                        ),

                      if (referredUser != null)
                        Column(
                          children: [
                            FirstRelationshipManagerCardWidget(referredUser: referredUser),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        referredUser = null;
                                        referralController.clear();
                                      });
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: textStyle14(context, color: Colors.red),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CustomContainer(
                                    onTap: isConfirming
                                        ? null
                                        : () async {
                                      if (referredUser == null) return;

                                      setState(() {
                                        isConfirming = true;
                                      });

                                      final success =
                                      await _referralServiceConfirm.setReferralForUser(
                                        userId: users.id,
                                        referralCode: referredUser!.referralCode,
                                      );

                                      if (success) {
                                        showCustomToast("Referral confirmed successfully!");
                                        setState(() {
                                          referralController.clear();
                                          referredUser = null;
                                        });
                                        context
                                            .read<UserBloc>()
                                            .add(FetchUserById(users.id));
                                      } else {
                                        showCustomToast("Failed to confirm referral.");
                                      }

                                      setState(() {
                                        isConfirming = false;
                                      });
                                    },
                                    child: Center(
                                      child: isConfirming
                                          ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                          : Text("Confirm", style: textStyle14(context)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                    ],
                  ),
                ),

                /// Tabs
                SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                      child:  Padding(
                        padding: EdgeInsets.symmetric(horizontal:10,vertical: 10),
                        child: CustomToggleTabs(
                          labels: ['Non-GP', 'Team-GP'],
                          selectedIndex: _tapIndex,
                          onTap: (index) {
                            setState(() {
                              _tapIndex = index;
                            });
                          },
                        ),
                      ),
                    )),


                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return
                        _tapIndex ==0 ? NonGpWidget() :TeamGpWidget();
                    },
                    childCount: 5,
                  ),
                ),


                SliverToBoxAdapter(child:SizedBox(height:10,)),

              ],
            ),
          );
        }

        return const SizedBox(); // fallback
      },
    );
  }
}



/// _StickyHeaderDelegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 50,
      child: Material( // Optional: for background color
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}