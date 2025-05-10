import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Team Lead', showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            /// Tabs
            Padding(
              padding: const EdgeInsets.all(10),
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
            SizedBox(height: 10,),
        
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
    );
  }
}

class TeamBuildSection extends StatelessWidget {
  const TeamBuildSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        50.height,
        /// Illustration or Banner
        CustomContainer(
          height: 200,
          width: double.infinity,
          margin: EdgeInsets.all(0),
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
        const SizedBox(height: 30),

        /// Upgrade Button
        CustomContainer(
          width: double.infinity,
          backgroundColor: CustomColor.appColor,
          onTap: () {},
          child: Center(child: const Text('Upgrade Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class MyTeamSection extends StatelessWidget {
  const MyTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        //const SizedBox(height: 30),
        Expanded(child: CustomContainer(
          margin: EdgeInsets.all(0),

        ))
      ],
    );
  }
}
