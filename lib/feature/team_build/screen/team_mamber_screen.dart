import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/feature/team_build/screen/team_leads_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../lead/bloc/team_lead/team_lead_bloc.dart';
import '../../lead/bloc/team_lead/team_lead_event.dart';
import '../../lead/bloc/team_lead/team_lead_state.dart';
import '../../lead/repository/lead_repository.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_bloc.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_event.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_state.dart';
import '../model/my_team_model.dart';
import '../repository/upcoming_lead_commission_repository.dart';
import '../widget/team_card_widget.dart';

class TeamMemberScreen extends StatelessWidget {
  final MyTeamModel members;
  const TeamMemberScreen({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final member = members.user;
    return Scaffold(
      appBar: CustomAppBar(title: 'Team Member', showBackButton: true,),

      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TeamCardWidget(
                  radius: 25,
                  backgroundImage: member!.profilePhoto != null && member.profilePhoto!.isNotEmpty
                      ? NetworkImage(member.profilePhoto!)
                      :  AssetImage(CustomImage.nullImage) as ImageProvider,
                  id: member!.id,
                  memberId: member.userId,
                  name: member.fullName,
                  // level: member.packageStatus,
                  level: member.packageStatus== 'nonGP'?'Non-GP':member.packageStatus,
                  status: member.isDeleted,
                  address: '______',
                  phone: member.mobileNumber,
                  earning: members.totalEarningsFromShare2?.toStringAsFixed(2),
                  // earning: 'My Earning\n₹ ${members.totalEarningsFromShare2?.toStringAsFixed(2)}',
                ),

                TabBar(
                  indicatorColor: CustomColor.appColor,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  dividerColor: WidgetStateColor.transparent,
                  tabs: [
                    Tab(text: 'Leads (${members.leads.length})'),
                    Tab(text: 'Teams (${members.team.length})'),
                  ],
                ),

                Expanded(
                  child: BlocProvider(
                    create: (context) => TeamLeadBloc(LeadRepository())..add(GetTeamLeadsByUser(member.id)),
                    child: TabBarView(
                     children: [
                       members.leads.isNotEmpty ? _MemberLeads(leadsData: members.leads,):
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.leaderboard, color: CustomColor.iconColor,size: 50,),
                           Text("No Leads"),
                         ],
                       ),

                       members.team.isNotEmpty ? _TeamMembers(members: members.team,):
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(CupertinoIcons.person_2_fill, color: CustomColor.iconColor,size: 50,),
                           Text("No Member"),
                         ],
                       )
                     ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// _MemberLeads
class _MemberLeads extends StatelessWidget {
  final List<Lead> leadsData;
  const _MemberLeads({super.key, required this.leadsData});

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<TeamLeadBloc, TeamLeadState>(
      builder: (context, state) {
        if (state is TeamLeadLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TeamLeadLoaded) {
          final allLeads = state.leadModel ?? [];

          return ListView.builder(
            itemCount: allLeads.length,
            itemBuilder: (context, index) {
              final leads = allLeads[index];
              final leadId = leads.id;
              final leadCommission = leadsData.cast<Lead?>().firstWhere(
                    (e) => e?.checkoutId == leadId,
                orElse: () => null,
              );


            return CustomContainer(
              color: CustomColor.whiteColor,
              margin: EdgeInsetsGeometry.only(top: 10),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('Booking ID: ${leads.bookingId}', style: textStyle12(context, fontWeight: FontWeight.w400),),
                       Text(leads.service!.serviceName.toString(), style: textStyle12(context, fontWeight: FontWeight.w400),),
                       Row(
                         children: [
                           CustomAmountText(amount: leads.service!.price.toString(),isLineThrough: true),10.width,
                           CustomAmountText(amount: formatPrice(leads.service!.discountedPrice!),isLineThrough: false),10.width,
                           Text('${leads.service!.discount.toString()} %', style: textStyle12(context, color: CustomColor.greenColor),),
                         ],
                       ),
                      Row(
                        children: [
                          Text('Status:', style: textStyle12(context, fontWeight: FontWeight.w400,),),10.width,
                          Text('[ ${getLeadStatus(leads)} ]', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: getStatusColor(leads)),),

                        ],
                      ),
                      10.height,

                      DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: [6, 3],
                          strokeWidth: 1,
                          radius: Radius.circular(8),
                          color: CustomColor.appColor,
                        ),
                         child: Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Column(
                                 children: [
                                   Text('Booking Date', style: textStyle12(context, color: CustomColor.descriptionColor),),
                                   Text('${formatDateTime(leads.createdAt)}', style: textStyle12(context, fontWeight: FontWeight.w400),),
                                 ],
                               ),
                               Column(
                                 children: [
                                   Text('Schedule Date', style: textStyle12(context, color: CustomColor.descriptionColor),),
                                   Text('${formatDateTime(leads.acceptedDate)}',style: textStyle12(context, fontWeight: FontWeight.w400),),
                                 ],
                               ),
                             ],
                           ),
                         ),
                       )
                    ],
                  ),

                  if (leadCommission != null && leadId != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: BlocProvider(
                        create: (context) => UpcomingCommissionBloc(UpcomingLeadCommissionRepository())
                          ..add(FetchUpcomingCommission(leadId)),
                        child: BlocBuilder<UpcomingCommissionBloc, UpcomingCommissionState>(
                          builder: (context, state) {
                            if (state is UpcomingCommissionLoading) {
                              return SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: CustomColor.appColor,
                                  ),
                                ),
                              );
                            }
                            else if (state is UpcomingCommissionLoaded) {
                              final data = state.commission.data;
                              return Column(
                                children: [
                                  if (!(leads.isAccepted ?? false))
                                    Text(
                                      'After Accepted\n₹ __',
                                      style: textStyle12(
                                        context,
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.appColor,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  if ((leads.isAccepted ?? false) && !(leads.isCompleted ?? false))
                                    Text(
                                      'Earning\nOpportunity ₹ ${data?.share2?.toStringAsFixed(2) ?? "__"}',
                                      style: textStyle12(
                                        context,
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.appColor,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  if (leads.isCompleted ?? false)
                                    Text(
                                      'My Earning\n₹ ${leadCommission.commissionEarned?.toStringAsFixed(2) ?? "0"}',
                                      style: textStyle12(
                                        context,
                                        fontWeight: FontWeight.w400,
                                        color: CustomColor.appColor,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                ],
                              );
                            }
                            else if (state is UpcomingCommissionError) {
                              return Text(
                                'After Accepted\n₹ __',
                                style: textStyle12(
                                  context,
                                  fontWeight: FontWeight.w400,
                                  color: CustomColor.appColor,
                                ),
                                textAlign: TextAlign.end,
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    )

                ],
              ),
            );
          },);

        } else if (state is TeamLeadError) {
          return Center(child: Text("❌ ${state.message}"));
        }
        return const Center(child: Text("No data"));
      },
    );
  }

  String getLeadStatus(lead) {
    if (lead.isCanceled ?? false) return 'Cancel';
    if (lead.isCompleted ?? false) return 'Completed';
    if (lead.isAccepted ?? false) return 'Accepted';
    return 'Pending';
  }

  Color getStatusColor(lead) {
    if (lead.isCanceled ?? false) return Colors.red;
    if (lead.isCompleted ?? false) return Colors.green;
    if (lead.isAccepted ?? false) return Colors.orange;
    return Colors.grey;
  }

}

/// _TeamMembers
class _TeamMembers extends StatelessWidget {
  final List<SubTeam> members;
  const _TeamMembers({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: members.length,
      // padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {

        final member = members[index].user;
        final teamCommission = members[index].totalEarningsFromShare3;
        final leadsData = members[index].leads;

        return TeamCardWidget(
          radius: 25,
          backgroundImage: member!.profilePhoto != null && member.profilePhoto!.isNotEmpty
              ? NetworkImage(member.profilePhoto!)
              :  AssetImage(CustomImage.nullImage) as ImageProvider,
          id: member!.id,
          memberId: member.userId,
          name: member.fullName,
          level: member.packageStatus== 'nonGP'?'Non-GP':member.packageStatus,
          status: member.isDeleted,
          address: '_______',
          phone: member.mobileNumber,
          earning: teamCommission?.toStringAsFixed(2),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeamLeadsScreen(
                  member: member,
                  earning: teamCommission.toString(),
                  leadsData: leadsData,
                ),
              ),
            );
          },
        );
      },);
  }
}




