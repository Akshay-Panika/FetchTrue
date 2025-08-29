import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/package/screen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';

class InviteFranchiseSectionWidget extends StatefulWidget {
  const InviteFranchiseSectionWidget({super.key});

  @override
  State<InviteFranchiseSectionWidget> createState() => _InviteFranchiseSectionWidgetState();
}

class _InviteFranchiseSectionWidgetState extends State<InviteFranchiseSectionWidget> {


  @override
  Widget build(BuildContext context) {

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
          return  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                children: [
                  50.height,

                  Row(
                    children: [
                      20.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Invite & Earn', style: textStyle20(context, color: CustomColor.appColor),),
                          Row(
                            children: [
                              Text('more than',style: textStyle20(context, color: Colors.green),),10.width,
                              Text('₹5000', style: textStyle18(context),),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Image.asset(CustomImage.inviteImage,)),
                    ],
                  ),

                  /// Referral Code Box
                  CustomContainer(
                    color: CustomColor.appColor,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Referral code', style: textStyle12(context, color: CustomColor.whiteColor),),
                            Text(user.packageActive != true ?'#XXXXXX':user.referralCode, style: textStyle20(context, color: CustomColor.whiteColor),),
                          ],
                        ),


                        const Spacer(),
                        InkWell(
                          onTap: () {
                            if(user.packageActive == true){
                              Clipboard.setData( ClipboardData(text: '${user.referralCode}'));
                            }
                            else{
                              showCustomToast('Please first active package');
                            }

                          },
                          child:  Icon(Icons.copy, color: CustomColor.whiteColor,),
                        ),
                        50.width,
                        InkWell(
                          onTap: () {
                            if(user.packageActive == true){
                              Share.share("Hey! Use my referral code 👉 ${user.referralCode} to signup and enjoy benefits.");
                            }
                            else{
                              showCustomToast('Please first active package');
                            }
                          },
                          child:  Icon(Icons.share, color: CustomColor.whiteColor, ),
                        ),
                        10.width
                      ],
                    ),
                  ),
                  50.height,


                  if(user.packageActive != true)
                  CustomContainer(color: CustomColor.appColor,
                    padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                    child: Text('Active Now', style: textStyle16(context, color: CustomColor.whiteColor),),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),)),
                  ),

                ],
              ),

              CustomContainer(height: 300,
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
            ],
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