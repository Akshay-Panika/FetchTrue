import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../../my_lead/bloc/leads/leads_bloc.dart';
import '../../my_lead/bloc/leads/leads_event.dart';
import '../../my_lead/bloc/leads/leads_state.dart';
import '../../my_lead/screen/leads_screen.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_event.dart';
import '../../profile/bloc/user_by_id_bloc/user_by_id_bloc.dart';
import '../../profile/bloc/user_by_id_bloc/user_by_id_event.dart';
import '../../profile/bloc/user_by_id_bloc/user_by_id_state.dart';
import '../../profile/model/user_model.dart';
import '../../profile/repository/user_by_id_repojetory.dart';


class TeamLeadDetailsScreen extends StatelessWidget {
  final String teamId;
  const TeamLeadDetailsScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Team Member', showBackButton: true,),

      body: BlocProvider(
          create: (_) => UserByIdBloc(UserByIdRepository())..add(GetUserById(teamId)),
          child: BlocBuilder<UserByIdBloc, UserByIdState>(
            builder: (context, state) {
              if (state is UserByIdLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserByIdLoaded) {
                UserModel user = state.user;

                return BlocProvider(
                  create: (_) => LeadsBloc()..add(FetchLeadsDataById(user.id)),
                  child:DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        _buildProfileHeader(context, user),
                        10.height,

                        BlocBuilder<LeadsBloc, LeadsState>(
                          builder: (context, state) {
                            int total = 0;

                            if (state is CheckoutLoaded) {
                              total = state.checkouts.length;
                            }

                            return TabBar(
                              tabs: [
                                Tab(text: 'Total Lead - $total'),
                                const Tab(text: 'Team - 457'),
                              ],
                              dividerColor: Colors.transparent,
                              indicatorColor: CustomColor.appColor,
                              labelColor: CustomColor.appColor,
                              unselectedLabelColor: CustomColor.descriptionColor,
                            );
                          },
                        ),


                        Expanded(
                          child: TabBarView(
                            children: [
                              SingleChildScrollView(child: _buildLead(context)),
                              _buildTeam(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
              } else if (state is UserByIdError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: Text('No user data'));
              }
            },
          )
      ),
    );
  }
}


Widget _buildProfileHeader(BuildContext context, UserModel user) {
  return CustomContainer(
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
              'My Earning ₹ 00',
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
  );
}

Widget _buildLead(BuildContext context) {
  return BlocBuilder<LeadsBloc, LeadsState>(
    builder: (context, state) {
      if (state is CheckoutLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is CheckoutLoaded) {
        final leads = state.checkouts;

        if (leads.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: const Center(child: Text("No leads found.")),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // To allow outer scroll
          itemCount: leads.length,
          itemBuilder: (context, index) {
            final lead = leads[index];

            return CustomContainer(
              border: true,
              backgroundColor: CustomColor.whiteColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(icon: Icon(Icons.timelapse, color: CustomColor.amberColor,),label: Text('In Progress', style: textStyle14(context, color: CustomColor.amberColor),), onPressed: () => null,),

                      CustomContainer(
                        border: true,
                        margin: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        child: Text(' 3 Day / 12:30 Hrs\nExpired',style: textStyle12(context, color: CustomColor.appColor),textAlign: TextAlign.end,),),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Earning Opportunity - 5643'),
                      Text('Follow up with the customer to completed the application it can take up 7 days to it tracked.')
                    ],
                  ),
                  20.height,

                  DottedBorder(
                    padding: EdgeInsets.all(15),
                    color: CustomColor.greyColor,
                    dashPattern: [10, 5], // 6px line, 3px gap
                    borderType: BorderType.RRect,
                    radius: Radius.circular(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Lead Date', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                            Text(DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(lead.createdAt)),style: textStyle14(context),)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Update Date', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                            Text('19-09-2024',style: textStyle14(context),)
                          ],
                        ),
                      ],
                    ),),
                  10.height,

                ],
              ),
            );
          },
        );
      }

      if (state is CheckoutError) {
        return Center(child: Text(state.message));
      }

      return const SizedBox.shrink(); // default empty widget
    },
  );
}

Widget _buildTeam(){
  return ListView.builder(
    itemCount: 5,
    padding: EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            backgroundColor: CustomColor.whiteColor,
            margin: EdgeInsets.only(top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CustomColor.appColor,
                          backgroundImage: AssetImage(CustomImage.nullImage),
                        ),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name'),
                            Text('Franchise code'),
                          ],
                        ),
                      ],
                    ),


                    CustomContainer(
                      margin: EdgeInsets.zero,
                      child: Text('My Earning\n500',style: textStyle12(context, color: CustomColor.appColor),textAlign: TextAlign.center,),)
                  ],
                ),
                Divider(),

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

              ],
            ),
          )
        ],
      );
    },);
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
