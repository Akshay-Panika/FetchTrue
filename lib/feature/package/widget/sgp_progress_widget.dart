import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';
import '../../team_build/model/my_team_model.dart';
import '../../team_build/screen/team_build_screen.dart';

class SgpProgressWidget extends StatelessWidget {
  final String userId;
  final int targetCount;

  const SgpProgressWidget({
    super.key,
    required this.userId,
    this.targetCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<MyTeamBloc, MyTeamState>(
      builder: (context, state) {
        if (state is MyTeamLoading) {
          return _shimmerEffect(dimensions);
        } else if (state is MyTeamLoaded) {

          final List<TeamData> team = state.response.team;

          if (team.isEmpty) {
           return SizedBox.shrink();
          }

          final gpMembers = team.where((e) => e.user?.packageActive == true && e.user?.packageStatus == 'GP').toList();

          final currentCount = gpMembers.length;
          final progress = (currentCount / targetCount).clamp(0.0, 1.0);

          return currentCount ==10 ?
          Padding(
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

                Text('Almost there! Build your team with just 2 more partners, you’ll become a PGP.', style: textStyle12(context, color: CustomColor.descriptionColor,fontWeight: FontWeight.w400),),
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
          )
          :SizedBox.shrink();

        } else if (state is MyTeamError) {
          print("Error: ${state.message}");
        }
        return const SizedBox();
      },
    );

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


Widget _shimmerEffect(Dimensions dimensions){

  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Fake progress bar shimmer
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 5,
              color: Colors.white,
            ),
          ),
          10.height,

          /// Fake labels shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(
                height: dimensions.screenHeight*0.025,
                width: dimensions.screenHeight*0.025,
              ),
              ShimmerBox(
                height: dimensions.screenHeight*0.025,
                width: dimensions.screenHeight*0.025,
              ),
            ],
          ),
          15.height,

          /// Fake button shimmer
          ShimmerBox(
            height: dimensions.screenHeight*0.03,
            width: double.infinity,
          ),
        ],
      ),
    ),
  );
}