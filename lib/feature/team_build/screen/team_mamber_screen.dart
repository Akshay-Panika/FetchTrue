// import 'package:dotted_border/dotted_border.dart';
// import 'package:fetchtrue/core/costants/dimension.dart';
// import 'package:fetchtrue/core/widgets/custom_appbar.dart';
// import 'package:fetchtrue/feature/team_build/screen/team_lead_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/costants/custom_color.dart';
// import '../../../core/costants/custom_icon.dart';
// import '../../../core/costants/custom_image.dart';
// import '../../../core/costants/text_style.dart';
// import '../../../core/widgets/custom_amount_text.dart';
// import '../../../core/widgets/custom_container.dart';
// import '../../../core/widgets/formate_price.dart';
// import '../../../helper/Contact_helper.dart';
// import '../../lead/bloc/leads/leads_bloc.dart';
// import '../../lead/bloc/leads/leads_event.dart';
// import '../../lead/bloc/leads/leads_state.dart';
// import '../bloc/upcoming_lead_commission/upcoming_lead_commission_bloc.dart';
// import '../bloc/upcoming_lead_commission/upcoming_lead_commission_event.dart';
// import '../bloc/upcoming_lead_commission/upcoming_lead_commission_state.dart';
// import '../model/my_team_model.dart';
// import '../repository/upcoming_lead_commission_repository.dart';
//
// class TeamMemberScreen extends StatelessWidget {
//   final TeamData member;
//   const TeamMemberScreen({super.key, required this.member});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = member.user;
//     String formatPrice(num value) {
//       return value.round().toString();
//     }
//     return Scaffold(
//       backgroundColor: CustomColor.whiteColor,
//       appBar: CustomAppBar(title:'My Member', showBackButton: true,),
//       body: SafeArea(
//         child: DefaultTabController(
//           length: 2,
//           child: Column(
//             children: [
//               CustomContainer(
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
//                           'My Earning ₹ ${formatPrice(member.totalEarningsFromShare2)}',
//                           // 'My Earning ₹ ${member.totalEarningsFromShare2}',
//                           style: textStyle12(context, color: CustomColor.appColor),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//
//                     5.height,
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Text(
//                           '${member.leads.length}\nTotal Lead',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: CustomColor.blueColor),
//                         ),
//                         Text(
//                           '${member.activeLeadCount}\nActive Lead',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: CustomColor.appColor),
//                         ),
//                         Text(
//                           '${member.completeLeadCount}\nCompleted Lead',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: CustomColor.greenColor),
//                         ),
//                       ],
//                     ),
//
//
//                     10.height,
//                     const Divider(thickness: 0.4, height: 0),
//                     10.height,
//
//                     /// Follow Up
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(' Self Follow Up', style: textStyle14(context, color: CustomColor.appColor)),
//                           Row(
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   ContactHelper.call(user.mobileNumber);
//                                 },
//                                 child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor),
//                               ),
//                               50.width,
//                               InkWell(
//                                 onTap: () {
//                                   ContactHelper.whatsapp(user.mobileNumber, 'Hello, ${user.userId}');
//                                 },
//                                 child: Image.asset(CustomIcon.whatsappIcon, height: 25),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               10.height,
//
//
//               TabBar(
//                 tabs: [
//                   Tab(text: 'Total Lead - ${member.leads.length}'),
//                   Tab(text: 'Team - ${member.team.length}'),
//                 ],
//                 // dividerColor: Colors.transparent,
//                 indicatorColor: CustomColor.appColor,
//                 labelColor: CustomColor.appColor,
//                 unselectedLabelColor: CustomColor.descriptionColor,
//               ),
//
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     SingleChildScrollView(child: _buildTotalLead(context, user.id, member)),
//                     _buildTotalTeam(context, member),
//                   ],
//                 ),
//               )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// Widget _buildTotalLead(BuildContext context, String userId, TeamData member) {
//
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'active':
//         return Colors.blue;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return CustomColor.descriptionColor;
//     }
//   }
//
//   return BlocProvider(
//     create: (_) => LeadsBloc()..add(FetchLeadsDataById(userId)),
//     child: BlocBuilder<LeadsBloc, LeadsState>(
//       builder: (context, state) {
//         if (state is LeadsLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state is LeadsLoaded) {
//           final leads = state.checkouts;
//
//           if (leads.isEmpty) {
//             return  Center(
//               child: Column(
//                 children: [
//                   200.height,
//                   Icon(Icons.leaderboard_outlined, size: 30,color: CustomColor.iconColor,),
//                   Text("Is Empty."),
//                 ],
//               ),
//             );
//           }
//
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: leads.length,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             itemBuilder: (context, index) {
//               final lead = leads[index];
//
//               final user = member.leads[index];
//                print('________________________${lead.id}');
//               return CustomContainer(
//                 border: true,
//                 margin: const EdgeInsets.only(top: 10),
//                 color: CustomColor.whiteColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(child: Text('${lead.service.serviceName}', style: textStyle12(context))),
//                             Text(
//                               '[ ${lead.orderStatus} ]',
//                               style: textStyle12(context, color: getStatusColor(lead.orderStatus)),
//                             ),
//                           ],
//                         ),
//                         Text('Lead Id: ${lead.bookingId}', style: textStyle12(context, )),
//                         5.height,
//
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Text('Amount: ', style: textStyle12(context)),
//                                 10.width,
//                                 CustomAmountText(amount: '${lead.service.price}', isLineThrough: true),
//                                 10.width,
//                                 // CustomAmountText(amount: '${formatPrice(lead.service.discountedPrice)}'),
//                               ],
//                             ),
//
//                             // Text('Commission Earned: ₹ ${formatPrice(user.commissionEarned)}', style: textStyle12(context),),
//
//                             BlocProvider(
//                               create: (_) => UpcomingLeadCommissionBloc(
//                                 repository: UpcomingLeadCommissionRepository(),
//                               )..add(FetchUpcomingLeadCommission(lead.id)),
//                               child: BlocBuilder<UpcomingLeadCommissionBloc, UpcomingLeadCommissionState>(
//                                 builder: (context, state) {
//                                   if (state is UpcomingLeadCommissionLoading) {
//                                     return const SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(strokeWidth: 2),
//                                     );
//                                   } else if (state is UpcomingLeadCommissionLoaded) {
//                                     final data = state.commission.data;
//                                     return Column(
//                                       children: [
//
//                                         if(user.commissionEarned == 0)
//                                         Text("Expected Earning: ₹ ${formatPrice(data.share1)}", style: textStyle12(context),),
//
//                                         if(user.commissionEarned != 0)
//                                         Text('Commission Earned: ₹ ${formatPrice(user.commissionEarned)}', style: textStyle12(context),),
//                                       ],
//                                     );
//                                   } else if (state is UpcomingLeadCommissionError) {
//                                      return Text('After Accepted Lead: ₹ __', style: textStyle12(context),);
//
//                                     // return Center(child: Text("Error: ${state.message}"));
//                                   }
//                                   return const SizedBox();
//                                 },
//                               ),
//                             )
//
//
//                           ],
//                         ),
//                         10.height,
//                       ],
//                     ),
//
//                     DottedBorder(
//                       padding: const EdgeInsets.all(15),
//                       color: CustomColor.greyColor,
//                       dashPattern: const [10, 5],
//                       borderType: BorderType.RRect,
//                       radius: const Radius.circular(8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Column(
//                             children: [
//                               Text('Booking Date',
//                                 style: textStyle14(context,fontWeight: FontWeight.w400),),
//                               Text(
//                                   formatDateTime(DateTime.parse(lead.createdAt)),
//                                   style: textStyle12(context, color: CustomColor.descriptionColor),)
//
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               Text('Schedule Date',
//                                 style: textStyle14(context,fontWeight: FontWeight.w400),),
//                               Text(
//                                 lead.acceptedDate != null && lead.acceptedDate!.isNotEmpty
//                                     ? formatDateTime(DateTime.parse(lead.acceptedDate!))
//                                     : "No date schedule",
//                                 style: textStyle12(context, color: CustomColor.descriptionColor),
//                               )
//
//
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         }
//
//         if (state is LeadsError) {
//           return Center(child: Text(state.message));
//         }
//
//         return const SizedBox.shrink();
//       },
//     ),
//   );
// }
//
// Widget _buildTotalTeam(BuildContext context, TeamData member) {
//   final validTeam = member.team.where((e) => e.user.id.isNotEmpty).toList();
//
//   if (validTeam.isEmpty) {
//     return  Center(
//       child: Column(
//         children: [
//           200.height,
//           Icon(Icons.leaderboard_outlined, size: 30,color: CustomColor.iconColor,),
//           Text("Is Empty."),
//         ],
//       ),
//     );
//   }
//
//
//   String formatPrice(num value) {
//     return value.round().toString();
//   }
//   return ListView.builder(
//     physics: const BouncingScrollPhysics(),
//     shrinkWrap: true,
//     itemCount: validTeam.length,
//     itemBuilder: (context, index) {
//       final data = validTeam[index];
//       final user = data.user;
//
//       return CustomContainer(
//         border: true,
//         color: CustomColor.whiteColor,
//         margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Stack(
//                       children: [
//                         CircleAvatar(
//                           radius: 25,
//                           backgroundColor: CustomColor.greyColor.withOpacity(0.2),
//                           backgroundImage: user.profilePhoto != null && user.profilePhoto!.isNotEmpty
//                               ? NetworkImage(user.profilePhoto!)
//                               : AssetImage(CustomImage.nullImage) as ImageProvider,
//                         ),
//                         Positioned(
//                           bottom: -2,
//                           right: -2,
//                           child: Icon(
//                             Icons.check_circle,
//                             size: 20,
//                             color: user.packageActive == true
//                                 ? CustomColor.greenColor
//                                 : Colors.grey.shade500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     10.width,
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Name: ${user.fullName}", style: textStyle14(context, fontWeight: FontWeight.w400)),
//                         Text('Id: ${user.userId}', style: textStyle14(context, fontWeight: FontWeight.w400)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Text(
//                   (data.totalEarningsFromShare3 == 0 || data.totalEarningsFromShare3 == null)
//                       ? 'Expected\nEarning: ₹ ${formatPrice(data.totalEarningsFromShare3)}'
//                       : 'My Earning: ₹ ${formatPrice(data.totalEarningsFromShare3)}',
//                   style: textStyle12(context, color: CustomColor.appColor,),textAlign: TextAlign.end,
//                 ),
//               ],
//             ),
//             10.height,
//             const Divider(thickness: 0.4),
//             5.height,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text('${data.leads.length}\nTotal Lead',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: CustomColor.blueColor)),
//                 Text('${data.activeLeadCount}\nActive Lead',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: CustomColor.appColor)),
//                 Text('${data.completeLeadCount}\nCompleted Lead',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: CustomColor.greenColor)),
//
//               ],
//             ),
//           ],
//         ),
//         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(userId: user.id,leadsData: data.leads,),)),
//       );
//     },
//   );
// }
