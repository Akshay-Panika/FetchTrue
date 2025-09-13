import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/team_build/model/my_team_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../team_build/screen/team_build_screen.dart';

class SgpProgressWidget extends StatelessWidget {
  final String userId;
  final int targetCount;
  final List<MyTeamModel> team;
  const SgpProgressWidget({
    super.key,
    required this.userId,
    this.targetCount = 3, required this.team,
  });

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    if (team.isEmpty) return SizedBox.shrink();

    final gpMembers = team.where((e) => e.user?.packageActive == true).toList();
    final sgpMembers = team.where((e) => e.user?.packageActive == true ).toList();

    final currentCount = sgpMembers.length;
    final progress = (currentCount / targetCount).clamp(0.0, 1.0);
    final remaining = (targetCount - currentCount).clamp(0, targetCount);

    return gpMembers.length < 9 ?  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(CustomColor.greenColor),
            ),
          ),

          10.height,

          /// 🔹 Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _labelBox(context, "$currentCount", CustomColor.greyColor),
              _labelBox(context, "$targetCount", CustomColor.greenColor),
            ],
          ),
          15.height,

          Text(
            remaining > 0
                ? 'Almost there! Build your team with just $remaining more partners, you’ll become a PGP.'
                : '🎉 Congratulations! You have completed your team and become a SGP!',
            style: textStyle12(
              context,
              color: CustomColor.descriptionColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          // Text('Almost there! Build your team with just 2 more partners, you’ll become a PGP.', style: textStyle12(context, color: CustomColor.descriptionColor,fontWeight: FontWeight.w400),),
          10.height,

          /// 🔹 Button
          CustomContainer(
            color: CustomColor.appColor,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 20, color: CustomColor.whiteColor),
                10.width,
                Text(
                  'Add Remaining Partners',
                  style: textStyle14(context, color: CustomColor.whiteColor),
                )
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  TeamBuildScreen(),
              ),
            ),
          )
        ],
      ),
    ):SizedBox.shrink();

  }

  Widget _labelBox(BuildContext context, String text, Color activeColor) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: activeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
