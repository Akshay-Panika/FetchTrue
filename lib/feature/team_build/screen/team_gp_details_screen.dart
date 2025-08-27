import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/feature/team_build/screen/team_lead_screen.dart';
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
import '../../../core/widgets/shimmer_box.dart';
import '../../../helper/Contact_helper.dart';
import '../../lead/bloc/leads/leads_bloc.dart';
import '../../lead/bloc/leads/leads_state.dart';
import '../../profile/model/user_model.dart';



class TeamGPDetailsScreen extends StatelessWidget {
  final String teamId;
  const TeamGPDetailsScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Team Member', showBackButton: true,),

      // body: SafeArea(
      //   child: BlocProvider(
      //       create: (_) => UserByIdBloc(UserByIdRepository())..add(GetUserById(teamId)),
      //       child: BlocBuilder<UserByIdBloc, UserByIdState>(
      //         builder: (context, state) {
      //           if (state is UserByIdLoading) {
      //             return const Center(child: CircularProgressIndicator());
      //           } else if (state is UserByIdLoaded) {
      //             UserModel user = state.user;
      //
      //             return MultiBlocProvider(
      //               providers: [
      //                 BlocProvider(
      //                   create: (_) => LeadsBloc()..add(FetchLeadsDataById(user.id)),
      //                 ),
      //                 BlocProvider(
      //                   create: (_) => AllUserBloc(AllUserRepository())..add(AllFetchUsers()),
      //                 ),
      //               ],
      //               child: DefaultTabController(
      //                 length: 2,
      //                 child: Column(
      //                   children: [
      //                     _buildProfileHeader(context, user),
      //                     10.height,
      //                     BlocBuilder<LeadsBloc, LeadsState>(
      //                       builder: (context, leadsState) {
      //                         int totalLeads = 0;
      //                         if (leadsState is CheckoutLoaded) {
      //                           totalLeads = leadsState.checkouts.length;
      //                         }
      //
      //                         return BlocBuilder<AllUserBloc, AllUserState>(
      //                           builder: (context, userState) {
      //                             int teamCount = 0;
      //                             if (userState is AllUserLoaded) {
      //                               teamCount = userState.users
      //                                   .where((rId) => rId.referredBy == user.id)
      //                                   .length;
      //                             }
      //
      //                             return TabBar(
      //                               tabs: [
      //                                 Tab(text: 'Total Lead - $totalLeads'),
      //                                 Tab(text: 'Team - $teamCount'),
      //                               ],
      //                               dividerColor: Colors.transparent,
      //                               indicatorColor: CustomColor.appColor,
      //                               labelColor: CustomColor.appColor,
      //                               unselectedLabelColor: CustomColor.descriptionColor,
      //                             );
      //                           },
      //                         );
      //                       },
      //                     ),
      //                     Expanded(
      //                       child: TabBarView(
      //                         children: [
      //                           SingleChildScrollView(child: _buildTotalLead(context)),
      //                           _buildTotalTeam(context, user.id),
      //                         ],
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             );
      //
      //           } else if (state is UserByIdError) {
      //             return Center(child: Text('Error: ${state.message}'));
      //           } else {
      //             return const Center(child: Text('No user data'));
      //           }
      //         },
      //       )
      //   ),
      // ),
    );
  }
}


Widget _buildProfileHeader(BuildContext context, UserModel user) {
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
            if (state is LeadsLoading) {
              return _buildShimmer();
            } else if (state is LeadsLoaded) {
              final leads = state.checkouts;

              // Total Lead
              final total = leads.length;

              // Active Lead -> Accepted but not Completed
              final active = leads.where((e) =>
              e.isAccepted == true && e.isCompleted != true
              ).length;

              // Completed Lead -> Completed true
              final completed = leads.where((e) =>
              e.isCompleted == true
              ).length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '$total\nTotal Lead',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CustomColor.blueColor),
                  ),
                  Text(
                    '$active\nActive Lead',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CustomColor.appColor),
                  ),
                  Text(
                    '$completed\nCompleted Lead',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CustomColor.greenColor),
                  ),
                ],
              );
            } else if (state is LeadsError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
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

Widget _buildTotalLead(BuildContext context,) {
  return BlocBuilder<LeadsBloc, LeadsState>(
    builder: (context, state) {
      if (state is LeadsLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is LeadsLoaded) {
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
              color: CustomColor.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lead.service.serviceName, style: textStyle12(context),),
                          Text('Lead Id: ${lead.bookingId}', style: textStyle12(context, fontWeight: FontWeight.w400),),
                          Row(
                            children: [
                              Text('Amount:', style: textStyle12(context, fontWeight: FontWeight.w400),),
                              10.width,
                              CustomAmountText(amount: lead.service.price.toString(), isLineThrough: true),
                              10.width,
                              CustomAmountText(amount: lead.service.discountedPrice.toString()),
                            ],
                          ),
                        ],
                      ),
                      Text('[ ${lead.orderStatus} ]', style: textStyle12(context, color: CustomColor.descriptionColor),)
                    ],
                  ),
                  5.height,

                  Text('Exacted Earning: 5643',style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.greenColor),),
                  5.height,

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

      if (state is LeadsError) {
        return Center(child: Text(state.message));
      }

      return const SizedBox.shrink(); // default empty widget
    },
  );
}

// Widget _buildTotalTeam(BuildContext context, String teamId){
//   return BlocBuilder<AllUserBloc, AllUserState>(
//     builder: (context, state) {
//       if (state is AllUserLoading) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (state is AllUserLoaded) {
//         // final users = state.users;
//         final users = state.users.where((rId) => rId.referredBy == teamId).toList();
//         if (users.isEmpty) {
//           return Padding(
//             padding:  EdgeInsets.only(top: 200.0),
//             child:  Center(
//               child: Text(
//                   "No Member",
//                   style: textStyle14(context)
//               ),
//             ),
//           );
//         }
//         return ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//
//             return BlocProvider(
//               create: (_) => LeadsBloc()..add(FetchLeadsDataById(user.id!)),
//               child: CustomContainer(
//                 border: true,
//                 color: CustomColor.whiteColor,
//                 margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// Header row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Stack(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 25,
//                                   backgroundColor: CustomColor.greyColor.withOpacity(0.2),
//                                   backgroundImage: user.profilePhoto != null && user.profilePhoto!.isNotEmpty
//                                       ? NetworkImage(user.profilePhoto!)
//                                       : AssetImage(CustomImage.nullImage) as ImageProvider,
//                                 ),
//                                 Positioned(
//                                   bottom: -2,
//                                   right: -2,
//                                   child: Icon(
//                                     Icons.check_circle,
//                                     size: 20,
//                                     color: user.packageActive == true
//                                         ? CustomColor.greenColor
//                                         : Colors.grey.shade500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             10.width,
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Name: ${user.fullName}", style: textStyle14(context, fontWeight: FontWeight.w400)),
//                                 Text('Id: ${user.userId}', style: textStyle14(context, fontWeight: FontWeight.w400)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Text(
//                           'My Earning ₹ 500',
//                           style: textStyle12(context, color: CustomColor.appColor),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//
//                     10.height,
//                     const Divider(thickness: 0.4, height: 0),
//                     5.height,
//
//                     /// 🟡 BlocBuilder: Leads Info Row
//                     BlocBuilder<LeadsBloc, LeadsState>(
//                       builder: (context, state) {
//                         if (state is CheckoutLoading) {
//                           return _buildShimmer();
//                         } else if (state is CheckoutLoaded) {
//                           final leads = state.checkouts;
//
//                           // Total Lead
//                           final total = leads.length;
//
//                           // Active Lead -> Accepted but not Completed
//                           final active = leads.where((e) =>
//                           e.isAccepted == true && e.isCompleted != true
//                           ).length;
//
//                           // Completed Lead -> Completed true
//                           final completed = leads.where((e) =>
//                           e.isCompleted == true
//                           ).length;
//
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 '$total\nTotal Lead',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: CustomColor.blueColor),
//                               ),
//                               Text(
//                                 '$active\nActive Lead',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: CustomColor.appColor),
//                               ),
//                               Text(
//                                 '$completed\nCompleted Lead',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: CustomColor.greenColor),
//                               ),
//                             ],
//                           );
//                         } else if (state is CheckoutError) {
//                           return Center(
//                             child: Text(
//                               "Error: ${state.message}",
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                           );
//                         } else {
//                           return const SizedBox.shrink();
//                         }
//                       },
//                     ),
//
//                   ],
//                 ),
//                 // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),
//               ),
//             );
//           },
//         );
//       } else if (state is AllUserError) {
//         return Center(child: Text(state.message));
//       }
//
//       return const SizedBox.shrink();
//     },
//   );
// }


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
