import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../bloc/package/package_bloc.dart';
import '../bloc/package/package_event.dart';
import '../bloc/reward/reward_bloc.dart';
import '../bloc/reward/reward_state.dart';
import '../bloc/reward_claim/reward_claim_bloc.dart';
import '../bloc/reward_claim/reward_claim_event.dart';
import '../bloc/reward_claim/reward_claim_state.dart';
import '../bloc/reward_claim_data/reward_claim_data_bloc.dart';
import '../bloc/reward_claim_data/reward_claim_data_event.dart';
import '../bloc/reward_claim_data/reward_claim_data_state.dart';
import '../model/reward_claim_model.dart';

class ClaimWidget extends StatefulWidget {
  final String selectedPlan;
  final String packageLevel;
  const ClaimWidget({Key? key, required this.selectedPlan, required this.packageLevel,}) : super(key: key);

  @override
  State<ClaimWidget> createState() => _ClaimWidgetState();
}

class _ClaimWidgetState extends State<ClaimWidget> {
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    context.read<ClaimNowDataBloc>().add(FetchClaimNowDataEvent());
  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);


    return BlocBuilder<RewardBloc, RewardState>(
      builder: (context, state) {
        if (state is RewardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RewardLoaded) {

          final filteredRewards = state.rewards.where((reward) {
            return reward.packageType.toLowerCase() == widget.selectedPlan.toLowerCase();
          }).toList();

          if (filteredRewards.isEmpty) {
            return const Center(
              child: Text("No rewards found for this plan"),
            );
          }

          final reward = filteredRewards.first;


          return  Padding(
            padding: EdgeInsets.all(10),
            child: BlocListener<RewardClaimBloc, RewardClaimState>(
            listener: (context, state) {
              if (state is RewardClaimSuccess) {
               showCustomToast(state.message);
               context.read<UserBloc>().add(GetUserById(userSession.userId!));
               context.read<PackageBloc>().add(FetchPackages());
              }
              if (state is RewardClaimError) {
                print(state.error);
              }
            },
              child: Column(
                children: [
                  Stack(
                  children: [
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        dashPattern: [15, 3],
                        strokeWidth: 1.5,
                        radius: Radius.circular(8),
                        color: CustomColor.appColor,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: CustomColor.whiteColor,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        padding: EdgeInsets.all(dimensions.screenWidth*0.05),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header Icon
                            Icon(
                              Icons.verified_outlined,
                              color: CustomColor.greenColor,
                              size: 28,
                            ),
                  
                  
                            // Title
                            Text('Select Your Reward Option', style: textStyle16(context, color: Colors.black54)),
                  
                            // Subtitle
                            Text(
                              'Choose any one option to claim or apply.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            20.height,
                  
                            // Option 1: iPhone Reward
                            _buildRewardOption(
                              index: 0,
                              imagePath: reward.photo,
                              title: reward.name ?? 'Claim Your Reward',
                              subtitle: reward.description,
                              icon: Icons.phone_iphone,
                              accentColor: Colors.orange,
                            ),
                            const SizedBox(height: 20),
                  
                            // OR Divider
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade400)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: textStyle14(context),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade400)),
                              ],
                            ),
                            const SizedBox(height: 20),
                  
                            // Option 2: Increase Earnings
                            _buildRewardOption(
                              index: 1,
                              imagePath: 'assets/earnings.png',
                              title: 'Increase Your Monthly Earning. \u20B9 ${reward.extraMonthlyEarn}',
                              subtitle: reward.extraMonthlyEarnDescription,
                              icon: Icons.trending_up,
                              accentColor: Colors.red,
                            ),
                            25.height,
                  
                            CustomButton(
                              label: 'Claim Reward',
                              isLoading: state is RewardClaimLoading,
                              onPressed: () {
                                if (selectedOption == null) {
                                  showCustomToast('Please select any option');
                                  return;
                                }
                  
                                final isReward = selectedOption == 0;
                                final isExtraMonth = selectedOption == 1;
                  
                                context.read<RewardClaimBloc>().add(
                                  SubmitClaimEvent(
                                    userId: userSession.userId!,
                                    rewardId: reward.id!,
                                    selectedIndex: selectedOption!,  // 0 or 1
                                  ),
                                );
                  
                              },
                            ),
                  
                  
                          ],
                        ),
                      ),
                    ),
                  
                    if (widget.packageLevel != 'GP')
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(widget.packageLevel),
                                Icon(
                                  Icons.lock,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                10.height,
                                Text(
                                  'Locked',
                                  style: textStyle16(context, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  
                  ],
                              ),

                  BlocBuilder<ClaimNowDataBloc, ClaimNowDataState>(
                    builder: (context, state) {
                      if (state is ClaimNowDataLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is ClaimNowDataError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is ClaimNowDataLoaded) {
                        final list = state.items;

                        if (list.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final matchingList = list.where((u) => u.user.id == userSession.userId).toList();

                        if (matchingList.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final user = matchingList.first;

                        return ClaimNowDataStatus(user: user);

                      }

                      return const SizedBox();
                    },
                  )
                ],
              ),
            ),
          );
        }

        if (state is RewardError) {
          print(state.message);
          return SizedBox.shrink();
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildRewardOption({
    required int index,
    required String imagePath,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    final isSelected = selectedOption == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isSelected ? Colors.green.shade400 : Colors.grey.shade300, width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                // Image/Icon Container
                CustomContainer(
                  height: 90,width: 90,
                  margin: EdgeInsets.zero,
                  networkImg: imagePath,
                ),
               10.width,

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.height,
                      Text('${title} ${index == 0 ?CustomLogEmoji.box:CustomLogEmoji.money}',
                        style: textStyle12(context, color: CustomColor.appColor),
                      ),
                     5.height,
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade400 : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.green.shade400 : Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 18,
                color: Colors.white,
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}



/// ClaimNowDataStatus
class ClaimNowDataStatus extends StatelessWidget {
  final ClaimNowDataModel user;
  const ClaimNowDataStatus({
    Key? key, required this.user,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          20.height,

          // Status Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(user.isAdminApproved == false ?'Reward Request Pending':'Reward Approved', style: textStyle14(context,color: user.isAdminApproved == false? Colors.red: Colors.green),),
               10.width,
               Icon(
                 user.isAdminApproved == false? Icons.hourglass_empty: Icons.verified_outlined,
                color: CustomColor.appColor,
                size: 20,
              ),
            ],
          ),
          10.height,
          // Status Message
           Text(
            'Your reward request is submitted.',
            style: textStyle12(context, color: Colors.grey.shade500),
          ),
           Text(
            'Admin will verify it soon.',
            style: textStyle12(context, color: Colors.grey.shade500),
          ),
          30.height,

          // Reward Image
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: NetworkImage(user.reward!.photo), fit: BoxFit.fill),
              ),
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(16),
            ),
          ),
          

          if(user.isAdminApproved == true)
          Column(
            children: [
              30.height,
              Text(user.reward!.name, style: textStyle14(context, color: Colors.black54),),
              Text(user.reward!.description, style: textStyle12(context, fontWeight: FontWeight.w400, color: Colors.grey.shade600),),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final currentStep = 1;
    return Row(
      children: [
        _buildStepCircle(1, currentStep >= 1),
        _buildStepLine(currentStep >= 2),
        _buildStepCircle(2, currentStep >= 2),
        _buildStepLine(currentStep >= 3),
        _buildStepCircle(3, currentStep >= 3),
      ],
    );
  }

  Widget _buildStepCircle(int step, bool isActive) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? CustomColor.appColor : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.blue.shade400 : Colors.grey.shade300,
      ),
    );
  }
}
