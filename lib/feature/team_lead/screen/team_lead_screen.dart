import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_icon.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import '../../../core/widgets/custom_toggle_taps.dart';

class TeamLeadScreen extends StatefulWidget {
  const TeamLeadScreen({super.key});

  @override
  State<TeamLeadScreen> createState() => _TeamLeadScreenState();
}

class _TeamLeadScreenState extends State<TeamLeadScreen> {
  int _tapIndex = 0;

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Team Lead', showBackButton: true),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              /// Tabs
              Padding(
                padding: EdgeInsets.all(dimensions.screenHeight*0.02),
                child: CustomToggleTabs(
                  labels: ['Team Build', 'My Team'],
                  selectedIndex: _tapIndex,
                  onTap: (index) {
                    setState(() {
                      _tapIndex = index;
                    });
                  },
                ),
              ),
              30.height,

              /// Tab Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _tapIndex == 0
                      ? const TeamBuildSection()
                      : const MyTeamSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamBuildSection extends StatelessWidget {
  const TeamBuildSection({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        50.height,
        /// Illustration or Banner
        CustomContainer(
          height: dimensions.screenHeight*0.2,
          width: double.infinity,
          margin: EdgeInsets.zero,
          assetsImg: CustomImage.inviteImage,
        ),
        20.height,
        Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Invite Friends & Businesses',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Share your referral code below and\ngrow your team.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),

            SizedBox(height: 60,),
          ],
        ),



        /// Referral Code Box
        DottedBorder(
          color: Colors.grey,
          dashPattern: [10, 5],
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          borderPadding: EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(width: 25,),
              Expanded(flex: 2,
                child: TextField(
                  readOnly: true,
                  decoration:  InputDecoration(
                   hintText: 'Akshay0001',
                    hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                    border: InputBorder.none, // removes all borders
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CustomContainer(
                  backgroundColor: CustomColor.appColor.withOpacity(0.8),
                  child: Icon(Icons.copy,color: Colors.white,)
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: dimensions.screenHeight*0.03),

        /// Upgrade Button
        CustomContainer(
          width: double.infinity,
          backgroundColor: CustomColor.appColor,
          onTap: () {},
          child: Center(child:  Text('Upgrade Now', style: textStyle16(context, color: CustomColor.whiteColor))),
        ),
         SizedBox(height: dimensions.screenHeight*0.05),
      ],
    );
  }
}

class MyTeamSection extends StatelessWidget {
  const MyTeamSection({super.key});

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return Column(
      children: [
        DottedBorder(
          color: Colors.grey,
          dashPattern: [10, 5], // 6px line, 3px gap
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          borderPadding: EdgeInsets.all(10),
          child: Row(
            children: [
               SizedBox(width: 25,),
              Expanded(flex: 2,
                child: TextField(
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),

                  decoration: const InputDecoration(
                    hintText: 'Referral Code...',
                    hintStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                    border: InputBorder.none, // removes all borders
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: CustomContainer(
                  backgroundColor: CustomColor.appColor.withOpacity(0.8),
                  child: Center(child: const Text('Update', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.white),)),
                ),
              ),
            ],
          ),
        ),

        Column(
          children: [
            CustomContainer(
              border: true,
              backgroundColor: CustomColor.whiteColor,
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(CustomImage.nullImage),
                        radius: 35,backgroundColor: CustomColor.whiteColor,),
                      10.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Franchise Head Name', style: textStyle14(context),),
                          Text('rank :', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                          Text('other :', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                        ],
                      ),
                    ],
                  ),

                  CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
                    borderColor: CustomColor.appColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Text('Leads :', style: textStyle14(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                        Row(
                          children: [
                            Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,),
                            50.width,
                            Image.asset(CustomIcon.whatsappIcon, height: 25,),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.02),
              child: Row(
                children: [
                  Expanded(child: CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
                    child: Center(child: Text('Cancel', style: textStyle16(context, color: CustomColor.redColor),)),)),
                  20.width,
                  Expanded(child: CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
                    child: Center(child: Text('Confirm', style: textStyle16(context, color: CustomColor.appColor),)),)),
                ],
              ),
            ),
            20.height,

            TabBar(
                labelColor: CustomColor.appColor,
                unselectedLabelColor: CustomColor.descriptionColor,
                indicatorColor: CustomColor.appColor,
                tabs: [
              Tab(text: 'User',),
              Tab(text: 'Franchise',),
              Tab(text: 'Earning',),
            ]),
            
            SizedBox(
              height: MediaQuery.of(context).size.height*0.3,
              child: TabBarView(
                  children: [
                Center(child: Text('No Data'),),
                Center(child: Text('No Data'),),
                Center(child: Text('No Data'),),
              ]),
            )
          ],
        )
      ],
    );
  }
}
