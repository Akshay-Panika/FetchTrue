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
import '../widget/team_user_widget.dart';

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
                padding: EdgeInsets.symmetric(horizontal:dimensions.screenHeight*0.02),
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
              // 10.height,

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

class TeamBuildSection extends StatefulWidget {
  const TeamBuildSection({super.key});

  @override
  State<TeamBuildSection> createState() => _TeamBuildSectionState();
}

class _TeamBuildSectionState extends State<TeamBuildSection> {

  bool _isUpgrate = false;

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
      _isUpgrate?
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
        ):
          CustomContainer(
            border: true,
            height: 100,
            backgroundColor: CustomColor.whiteColor,
            // backgroundColor: CustomColor.appColor.withOpacity(0.1),
            margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, color: CustomColor.appColor,),
                10.width,
                Text('Upgrade now to start earning', style: textStyle16(context, color: CustomColor.appColor),)
              ],
            ),
          ),

        SizedBox(height: dimensions.screenHeight*0.03),

        /// Upgrade Button
        _isUpgrate ?
        CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: IconButton(onPressed: (){}, icon: Icon(Icons.share, color: CustomColor.appColor,))):
        CustomContainer(
          width: 200,
          backgroundColor: CustomColor.appColor,
          onTap: () {
            setState(() {
              _isUpgrate= true;
            });
          },
          child: Center(child:  Text('Upgrade Now', style: textStyle16(context, color: CustomColor.whiteColor))),
        ),
         SizedBox(height: dimensions.screenHeight*0.05),
      ],
    );
  }
}

class MyTeamSection extends StatefulWidget {
  const MyTeamSection({super.key});

  @override
  State<MyTeamSection> createState() => _MyTeamSectionState();
}

class _MyTeamSectionState extends State<MyTeamSection> {

  bool _isUpade = false;
  bool _confirm = false;

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return Column(
      children: [
        30.height,
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
                  onTap: () {
                    setState(() {
                      _isUpade = true;
                    });
                  },
                  child: Center(child: const Text('Update', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.white),)),
                ),
              ),
            ],
          ),
        ),

       if(_isUpade)
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

            if(!_confirm)
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.02),
              child: Row(
                children: [
                  Expanded(child: CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
                    onTap: () {
                      setState(() {
                        _confirm = true;
                      });
                    },
                    child: Center(child: Text('Cancel', style: textStyle16(context, color: CustomColor.redColor),)),)),
                  20.width,
                  Expanded(child: CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
                    onTap: () {
                      setState(() {
                        _confirm = true;
                      });
                    },
                    child: Center(child: Text('Confirm', style: textStyle16(context, color: CustomColor.appColor),)),)),
                ],
              ),
            ),

          ],
        ),

        Column(
          children: [
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
              height: MediaQuery.of(context).size.height*0.35,
              child: TabBarView(
                  children: [
                    TeamUserWidget(),
                    TeamUserWidget(),
                    TeamUserWidget(),
                  ]),
            )
          ],
        )
      ],
    );
  }
}
