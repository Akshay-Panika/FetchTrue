import 'package:bizbooster2x/core/costants/custom_color.dart';
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
        /// Illustration or Banner
        Expanded(
          child: CustomContainer(
            child:  Center(
              child: Icon(Icons.groups, size: 80, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 30),

        const Text(
          'Invite Friends & Businesses',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Share your referral code below and grow your team.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),

        /// Referral Code Box
        DottedBorder(
          color: Colors.grey,
          dashPattern: [10, 5],
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          borderPadding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration:  InputDecoration(
                   hintText: 'Akshay0001',
                    border: InputBorder.none, // removes all borders
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              CustomContainer(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                backgroundColor: CustomColor.appColor.withOpacity(0.8),
                child: Icon(Icons.copy,color: Colors.white,)
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
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Referral Code...',
                    border: InputBorder.none, // removes all borders
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              CustomContainer(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                backgroundColor: CustomColor.appColor.withOpacity(0.8),
                child: const Text('Update', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.white),),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Expanded(child: CustomContainer())
      ],
    );
  }
}
