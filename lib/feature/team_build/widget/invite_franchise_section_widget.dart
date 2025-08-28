import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/feature/package/screen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';

class InviteFranchiseSectionWidget extends StatefulWidget {
  const InviteFranchiseSectionWidget({super.key});

  @override
  State<InviteFranchiseSectionWidget> createState() => _InviteFranchiseSectionWidgetState();
}

class _InviteFranchiseSectionWidgetState extends State<InviteFranchiseSectionWidget> {


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {

        if (state is UserInitial) {
          return CircularProgressIndicator();
        }
        else if(state is UserLoading){
          return CircularProgressIndicator();
        }
        else if (state is UserLoaded) {
          final user = state.user;
          return  SingleChildScrollView(
            child: Column(
              children: [
                20.height,
                // Hero Section
                Column(
                  children: [

                    Row(
                      children: [
                        20.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Invite & Earn', style: textStyle20(context, color: CustomColor.appColor),),
                                10.width,
                                Text('more than',style: textStyle16(context, color: Colors.green),),
                              ],
                            ),
                            Row(
                              children: [
                                 Text('₹5000', style: textStyle18(context),),
                                  Text('/month!', style: textStyle14(context),),
                              ],
                            ),
                          ],
                        ),
                        Expanded(child: Image.asset(CustomImage.inviteImage,)),
                      ],
                    ),

                    // Referral Code Box
                    CustomContainer(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text('Referral code', style: textStyle14(context),),
                         15.width,
                           Text(user.referralCode, style: textStyle18(context, color: CustomColor.appColor),),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: 'NL4Q1ZMF'));
                            },
                            child:  Icon(Icons.copy, color: CustomColor.appColor,),
                          ),
                          20.width,
                          InkWell(
                            onTap: () {
                              // Share functionality
                            },
                            child:  Icon(Icons.share, color: CustomColor.appColor, ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

                20.height,


                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '₹0',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'My Earning',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFE0E0E0),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '₹0',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Team Earning',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                30.height,


                // How to earn section
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('How to earn assured cash?', style: textStyle14(context),),
                      20.height,

                      // Step 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: CustomColor.appColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Click on "Invite Now" button',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Step 2
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: CustomColor.appColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Invite your friends',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Step 3
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: CustomColor.appColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                '3',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                                children: [
                                  TextSpan(text: 'Your friend earns '),
                                  TextSpan(
                                    text: 'up to ₹1,000',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: ' after they get a loan'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.wallet, color: CustomColor.appColor,),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                                children: [
                                  TextSpan(text: 'For every friend who takes a build team , you earn '),
                                  TextSpan(
                                    text: 'up to ₹5,000',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                50.height,


                CustomContainer(color: CustomColor.appColor,
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  child: Text('Active Now', style: textStyle16(context, color: CustomColor.whiteColor),),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),)),
                )

              ],
            ),
          );
        }
        else if (state is UserError) {
          return Center(child: Text("Error: ${state.massage}"));
        }
        return const SizedBox();
      },
    );
  }
}


  Widget _buildSuccessStory(String name, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Color(0xFFFFB400),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$name earned $amount',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }