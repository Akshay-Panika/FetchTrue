import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/my_team/my_team_bloc.dart';
import '../bloc/my_team/my_team_event.dart';
import '../bloc/my_team/my_team_state.dart';
import '../repository/my_team_repository.dart';
import '../screen/team_gp_details_screen.dart';
import '../screen/team_mamber_screen.dart';

class MyGpTeamSection extends StatelessWidget {
  const MyGpTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context, listen: false);

    String formatPrice(num value) {
      return value.round().toString();
    }
    return BlocProvider(
      create: (context) =>
      MyTeamBloc(MyTeamRepository())..add(GetMyTeam(userSession.userId!)),
      child: BlocBuilder<MyTeamBloc, MyTeamState>(
        builder: (context, state) {
          if (state is MyTeamLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyTeamLoaded) {
            // final team = state.myTeam.team;

            final team = state.myTeam.team
                .where((member) => member.user.packageActive == true)
                .toList();

            if (team.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    200.height,
                    Icon(Icons.group_off, size: 45, color: Colors.grey),
                    10.height,
                    Text(
                      "No team members.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: team.length,
              itemBuilder: (context, index) {
                final user = team[index].user;
                final lead = team[index].leads;

                return CustomContainer(
                  border: true,
                  color: CustomColor.whiteColor,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                                    backgroundImage: user.profilePhoto != null && user.profilePhoto!.isNotEmpty
                                        ? NetworkImage(user.profilePhoto!)
                                        : AssetImage(CustomImage.nullImage) as ImageProvider,
                                  ),
                                  Positioned(
                                    bottom: -2,
                                    right: -2,
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 20,
                                      color: user.packageActive == true
                                          ? CustomColor.greenColor
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              10.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name: ${user.fullName}", style: textStyle14(context, fontWeight: FontWeight.w400)),
                                  Text('Id: ${user.userId}', style: textStyle14(context, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            'My Earning ₹ ${formatPrice(team[index].totalEarningsFromShare2)}',
                            style: textStyle12(context, color: CustomColor.appColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      5.height,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${lead.length}\nTotal Lead',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: CustomColor.blueColor),
                          ),
                          Text(
                            '${team[index].activeLeadCount}\nActive Lead',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: CustomColor.appColor),
                          ),
                          Text(
                            '${team[index].completeLeadCount}\nCompleted Lead',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: CustomColor.greenColor),
                          ),
                        ],
                      ),


                      10.height,
                      const Divider(thickness: 0.4, height: 0),
                      10.height,

                      /// Follow Up
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(' Self Follow Up', style: textStyle14(context, color: CustomColor.appColor)),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    ContactHelper.call(user.mobileNumber);
                                  },
                                  child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor),
                                ),
                                50.width,
                                InkWell(
                                  onTap: () {
                                    ContactHelper.whatsapp(user.mobileNumber, 'Hello, ${user.userId}');
                                  },
                                  child: Image.asset(CustomIcon.whatsappIcon, height: 25),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamMemberScreen(
                  //   index: index,
                  //   member: team[index],
                  // ),)),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamMemberScreen(member: team[index]),
                    ),
                  ),

                );
              },
            );
          } else if (state is MyTeamError) {
            return Text('Error: ${state.message}');
          }
          return const SizedBox();
        },
      ),
    );
  }
}
