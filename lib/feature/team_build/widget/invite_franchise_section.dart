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

class InviteFranchiseSection extends StatefulWidget {
  const InviteFranchiseSection({super.key});

  @override
  State<InviteFranchiseSection> createState() => _InviteFranchiseSectionState();
}

class _InviteFranchiseSectionState extends State<InviteFranchiseSection> {


  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            
                Container(
                  margin: EdgeInsets.all(dimensions.screenHeight*0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(dimensions.screenHeight*0.01),
                      topRight: Radius.circular(dimensions.screenHeight*0.01),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      CustomColor.whiteColor,
                      Colors.grey.shade100,
                    ])
                  ),
                  child: Column(
                    children: [
                     SizedBox(height: dimensions.screenHeight*0.05,),
                  
                      Row(
                        children: [
                          SizedBox(width: dimensions.screenHeight*0.020,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Invite & Earn', style: textStyle18(context, color: CustomColor.blackColor),),
                              Row(
                                children: [
                                  Text('more than',style: textStyle16(context, color: CustomColor.appColor),),10.width,
                                  Text('₹5000', style: textStyle18(context, color: CustomColor.greenColor),),
                                ],
                              ),
                            ],
                          ),
                          Expanded(child: Image.asset(CustomImage.inviteImage,)),
                        ],
                      ),
                      SizedBox(height: dimensions.screenHeight*0.02,),
                  
                      /// Referral Code Box
                      Center(
                        child: Container(

                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: CustomColor.appColor,
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: dimensions.screenHeight*0.03,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Referral code', style: textStyle12(context, color: CustomColor.greyColor),),
                                  Text(user.packageActive != true ?'#XXXXXX':user.referralCode, style: textStyle18(context, color: CustomColor.whiteColor),),
                                ],
                              ),
                              Spacer(),

                              Container(
                                padding: EdgeInsets.all(dimensions.screenHeight*0.015),
                                decoration: BoxDecoration(
                                  border: Border.all(color: CustomColor.appColor),
                                  borderRadius: BorderRadius.circular(25),
                                  color: CustomColor.whiteColor,
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if(user.packageActive == true){
                                          Clipboard.setData( ClipboardData(text: '${user.referralCode}'));
                                        }
                                        else{
                                          showCustomToast('Please first active package');
                                        }

                                      },
                                      child:  Icon(Icons.copy, color: CustomColor.appColor,),
                                    ),
                                    SizedBox(width: dimensions.screenHeight*0.05,),
                                    InkWell(
                                      onTap: () {
                                        if(user.packageActive == true){
                                          Share.share("Hey! Use my referral code 👉 ${user.referralCode} to signup and enjoy benefits.");
                                        }
                                        else{
                                          showCustomToast('Please first active package');
                                        }
                                      },
                                      child:  Icon(Icons.share, color: CustomColor.appColor, ),
                                    ),
                                    10.width
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: dimensions.screenHeight*0.05,),


                      CustomContainer(
                       color: Colors.grey.shade200,
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
                      SizedBox(height: dimensions.screenHeight*0.05,),

                      if(user.packageActive != true)
                      CustomContainer(color: CustomColor.appColor,
                        padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.05,vertical: dimensions.screenHeight*0.01),
                        child: Text('Active Now', style: textStyle14(context, color: CustomColor.whiteColor),),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),)),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          );
        }
        else if (state is UserError) {
          print('Error: ${state.massage}');
          return Center(child: Text('Try to sum time'));
          
        }
        return const SizedBox();
      },
    );
  }
}