import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/package/screen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
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
                     SizedBox(height: dimensions.screenHeight*0.02,),
                      Text('Turn Your Network into Income!', style: textStyle20(context),),
                      Text('Know someone who wants to start a business or explore extra earning opportunities?', style: textStyle12(context, fontWeight: FontWeight.w400, color: Colors.grey.shade600),textAlign: TextAlign.center,),
                      SizedBox(height: dimensions.screenHeight*0.02,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: 'Refer them to ',

                              ),
                              TextSpan(
                                text: 'Fetch True Franchisee',
                                style: TextStyle(color: Colors.blue,),
                              ),
                              TextSpan(
                                text: ' and earn ',
                              ),
                              TextSpan(
                                text: '₹5,000',
                                style: TextStyle(color: Colors.green,),
                              ),
                              TextSpan(
                                text: ' for every successful onboarding💰',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: dimensions.screenHeight*0.02,),

                      CustomContainer(
                        height: dimensions.screenHeight*0.4,
                        assetsImg: 'assets/package/refer_earn_bannar.jpg',
                      ),

                      /// Referral Code Box
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: [6, 3],
                            strokeWidth: 1,
                            radius: Radius.circular(10),
                            color: CustomColor.greenColor,
                            padding: EdgeInsets.all(10)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: dimensions.screenHeight*0.03,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Your Referral code', style: textStyle12(context, color: CustomColor.greyColor),),
                                  Text(user.packageActive != true ?'#XXXXXX':user.referralCode, style: textStyle18(context, color: CustomColor.blackColor),),
                                ],
                              ),
                              Spacer(),

                              Row(
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
                                    child:  Icon(Icons.copy, color: CustomColor.greenColor,),
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
                                    child:  Icon(Icons.share, color: CustomColor.greenColor, ),
                                  ),
                                  10.width
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: dimensions.screenHeight*0.02,),

                      CustomContainer(
                        color: CustomColor.whiteColor,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Benefits', style: textStyle12(context),),
                            10.height,

                            RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 12, color: Colors.black),
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0,right: 5),
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.black,
                                        size: 8,
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: 'Get'),
                                  TextSpan(
                                    text: ' \u20B9 5000',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: ' cash reward for every new person you refer who on-boards.\n\n'),

                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0,right: 5),
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.black,
                                        size: 8,
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: 'Earn'),
                                  TextSpan(
                                    text: ' \u20B9 3000',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: ' bonus every time your franchise brings in another franchise.\n\n'),

                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0,right: 5),
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.black,
                                        size: 8,
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: 'Enjoy '),
                                  TextSpan(
                                    text: ' 3-7%',
                                    style: TextStyle(color: CustomColor.appColor, fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: ' revenue share from your direct franchisee\'s business.\n\n'),

                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0,right: 5),
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.black,
                                        size: 8,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Build your team and unlock the potential to earn',
                                  ),
                                  TextSpan(text: ' \u20B9 1,00,000 +',
                                    style: TextStyle(color: CustomColor.greenColor, fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: ' every month!'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      CustomContainer(
                        color: Colors.blue.shade50,
                        child: Column(
                          children: [
                            Text("Don't just dream of financial freedom create it", style: textStyle14(context),),
                            10.height,

                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(fontSize: 14, color: Colors.black),
                                children: [
                                  TextSpan(text: 'One referral today can unlock the potential to earn'),
                                  TextSpan(
                                    text: ' \u20B9 1,00,000 +',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: ' every month!'),

                                ]
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: dimensions.screenHeight*0.02,),

                if(user.packageActive != true)
                CustomContainer(color: CustomColor.appColor,
                  padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.05,vertical: dimensions.screenHeight*0.01),
                  child: Text('Active Now', style: textStyle14(context, color: CustomColor.whiteColor),),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),)),
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