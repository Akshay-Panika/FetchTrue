import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/my_lead/bloc/leads/leads_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../my_lead/bloc/leads/leads_event.dart';
import '../../my_lead/bloc/leads/leads_state.dart';
import '../../my_lead/screen/leads_screen.dart';
import '../../profile/bloc/all_user_bloc/all_user_bloc.dart';
import '../../profile/bloc/all_user_bloc/all_user_event.dart';
import '../../profile/bloc/all_user_bloc/all_user_state.dart';
import '../../profile/repository/all_user_repository.dart';
import '../../../helper/Contact_helper.dart';
import '../screen/team_lead_details_screen.dart';


class TeamGpWidget extends StatelessWidget {
  const TeamGpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllUserBloc(AllUserRepository())..add(AllFetchUsers()),
      child: BlocBuilder<AllUserBloc, AllUserState>(
        builder: (context, state) {
          if (state is AllUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllUserLoaded) {
            final users = state.users;

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return BlocProvider(
                  create: (_) => LeadsBloc()..add(FetchLeadsDataById(user.id!)),
                  child: CustomContainer(
                    border: true,
                    backgroundColor: CustomColor.whiteColor,
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
                              'My Earning ₹ 500',
                              style: textStyle12(context, color: CustomColor.appColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        5.height,

                        /// 🟡 BlocBuilder: Leads Info Row
                        BlocBuilder<LeadsBloc, LeadsState>(
                          builder: (context, state) {
                            if (state is CheckoutLoading) {
                              return _buildShimmer();
                            } else if (state is CheckoutLoaded) {
                              final leads = state.checkouts;

                              final total = leads.length;
                              final active = leads.where((e) =>
                              e.orderStatus.toLowerCase() == 'pending' ||
                                  e.orderStatus.toLowerCase() == 'processing').length;
                              final completed = leads.where((e) =>
                              e.orderStatus.toLowerCase() == 'completed').length;

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('$total\nTotal Lead', textAlign: TextAlign.center, style: TextStyle(color: CustomColor.blueColor)),
                                  Text('$active\nActive Lead', textAlign: TextAlign.center, style: TextStyle(color: CustomColor.appColor)),
                                  Text('$completed\nCompleted Lead', textAlign: TextAlign.center, style: TextStyle(color: CustomColor.greenColor)),
                                ],
                              );
                            } else if (state is CheckoutError) {
                              return Center(child: Text("Error: ${state.message}", style: const TextStyle(color: Colors.red)));
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
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
                    
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadDetailsScreen(teamId: user.id,),)),
                  ),
                );
              },
            );
          } else if (state is AllUserError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}


Widget _buildShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        3,
            (index) => Column(
          children: [
            ShimmerBox(height: 10, width: 20),
            5.height,
            ShimmerBox(height: 10, width: 50),
          ],
        ),
      ),
    ),
  );
}
