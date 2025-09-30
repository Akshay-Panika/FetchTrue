import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/formate_price.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_state.dart';
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

class TeamLeadsScreen extends StatelessWidget {
  final User member;
  final String earning;
  final List<Lead> leadsData;
  const TeamLeadsScreen({super.key, required this.member, required this.earning,required this.leadsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${member.fullName}', showBackButton: true,),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TeamCardWidget(
              radius: 25,
              backgroundImage: AssetImage(CustomImage.nullImage),
              id: member.id,
              memberId: member.userId,
              name: member.fullName,
              level: member.packageStatus== 'nonGP'?'Non-GP':member.packageStatus,
              status: member.isDeleted,
              address: _getMemberAddress(member),
              phone: member.mobileNumber,
              earning: earning.toString(),
            ),

            _MemberLeads(leadsData: leadsData,member: member,),
          ],
        ),
      ),
    );
  }
  String _getMemberAddress(User member) {
    Address? address;

    if (member.homeAddress != null &&
        _isAddressValid(member.homeAddress!)) {
      address = member.homeAddress;
    } else if (member.workAddress != null &&
        _isAddressValid(member.workAddress!)) {
      address = member.workAddress;
    } else if (member.otherAddress != null &&
        _isAddressValid(member.otherAddress!)) {
      address = member.otherAddress;
    }

    if (address != null) {
      List<String> parts = [
        address.houseNumber,
        address.landmark,
        address.city,
        address.state,
        address.pinCode,
        address.country
      ];
      return parts.where((part) => part.isNotEmpty).join(", ");
    }

    return "";
  }

  bool _isAddressValid(Address address) {
    return address.houseNumber.isNotEmpty ||
        address.landmark.isNotEmpty ||
        address.city.isNotEmpty ||
        address.state.isNotEmpty ||
        address.pinCode.isNotEmpty ||
        address.country.isNotEmpty;
  }
}

class _MemberLeads extends StatelessWidget {
  final User member;
  final List<Lead> leadsData;
  const _MemberLeads({super.key, required this.leadsData, required this.member});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => TeamLeadBloc(LeadRepository())..add(GetTeamLeadsByUser(member.id)),
      child: BlocBuilder<TeamLeadBloc, TeamLeadState>(
        builder: (context, state) {
          if (state is TeamLeadLoading) {
            return Expanded(child: Center(child: CircularProgressIndicator(color: CustomColor.appColor,)));
          } else if (state is TeamLeadLoaded) {


            final allLeads = state.leadModel ?? [];

            final acceptedLeads = allLeads.where((e) => e.isAccepted == true && e.isCompleted == false && e.isCanceled == false).toList();
            final completedLeads = allLeads.where((e) => e.isCompleted == true).toList();


            if(allLeads.isEmpty){
              return
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.leaderboard, color: CustomColor.iconColor,size: 50,),
                    Text("No Leads"),
                  ],
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
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
                                CustomAmountText(amount: leads.service!.discountedPrice.toString(),isLineThrough: false),10.width,
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
                                            'Earning\nOpportunity ₹ ${data?.share3.toStringAsFixed(2) ?? "__"}',
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
                },),
            );

          } else if (state is TeamLeadError) {
            return Center(child: Text("❌ ${state.message}"));
          }
          return const Center(child: Text("No data"));
        },
      ),
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