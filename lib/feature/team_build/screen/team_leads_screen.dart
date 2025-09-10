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
              level: 'GP',
              address: 'address',
              phone: member.mobileNumber,
              earning: 'My Earning\n₹ ${earning}',
            ),

            _MemberLeads(leadsData: leadsData,),
          ],
        ),
      ),
    );
  }
}

class _MemberLeads extends StatelessWidget {
  final List<Lead> leadsData;
  const _MemberLeads({super.key, required this.leadsData});

  @override
  Widget build(BuildContext context) {

    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
          return Colors.orange;
        case 'processing':
          return CustomColor.appColor;
        case 'pending':
          return Colors.orange;
        case 'cancelled':
          return Colors.red;
        default:
          return CustomColor.descriptionColor;
      }
    }

    return BlocBuilder<LeadBloc, LeadState>(
      builder: (context, state) {
        if (state is LeadLoading) {
          return Expanded(child: Center(child: CircularProgressIndicator(color: CustomColor.appColor,)));
        } else if (state is LeadLoaded) {


          final allLeads = state.leadModel.data ?? [];

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
                              Text(
                                '${leads.orderStatus[0].toUpperCase()}${leads.orderStatus.substring(1).toLowerCase()}',
                                style: textStyle12(
                                  context,
                                  fontWeight: FontWeight.w400,
                                  color: getStatusColor(leads.orderStatus),
                                ),
                              ),
                            ],
                          ),
                          10.height,
            
                          DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              dashPattern: [10, 5],
                              strokeWidth: 2,
                              radius: Radius.circular(16),
                              color: Colors.indigo,
                              padding: EdgeInsets.all(16),
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

                      if (leadCommission != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: BlocProvider(
                            create: (context) =>
                            UpcomingCommissionBloc(UpcomingLeadCommissionRepository())
                              ..add(FetchUpcomingCommission(leadId!)),
                            child: BlocBuilder<UpcomingCommissionBloc, UpcomingCommissionState>(
                              builder: (context, state) {
                                if (state is UpcomingCommissionLoading) {
                                  return SizedBox(
                                      height: 20,width: 20,
                                      child:  Center(child: CircularProgressIndicator(strokeWidth: 3,color: CustomColor.appColor,)));
                                } else if (state is UpcomingCommissionLoaded) {
                                  final data = state.commission.data!;
                                  // return Column(
                                  //   children: [
                                  //
                                  //     if(leadCommission == 0)
                                  //       Text(
                                  //         'Earning\nOpportunity ₹ ${data.share3}',
                                  //         style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),
                                  //         textAlign: TextAlign.end,
                                  //       ),
                                  //
                                  //     if(leadCommission != 0)
                                  //       Text(
                                  //         'My Earning\n₹ ${leadCommission.commissionEarned ?? 0}',
                                  //         style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),
                                  //         textAlign: TextAlign.end,
                                  //       ),
                                  //   ],
                                  // );

                                  return Column(
                                    children: [

                                      if(leads.isAccepted == false)
                                        Text(
                                          'After Accepted\n₹ __',
                                          style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),
                                          textAlign: TextAlign.end,
                                        ),

                                      if(leads.isAccepted == true && leads.isCompleted == false)
                                        Text(
                                          'Earning\nOpportunity ₹ ${data.share3.toStringAsFixed(2)}',
                                          style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),
                                          textAlign: TextAlign.end,
                                        ),

                                      if(leads.isCompleted == true)
                                        Text(
                                          'My Earning\n₹ ${leadCommission.commissionEarned ?? 0}',
                                          style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),
                                          textAlign: TextAlign.end,
                                        ),
                                    ],
                                  );

                                } else if (state is UpcomingCommissionError) {
                                  return Text('After Accepted\n₹ __', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor), textAlign: TextAlign.end,);
                                }
                                return SizedBox.shrink();
                              },
                            )
                          ),
                        )

                    ],
                  ),
                );
              },),
          );

        } else if (state is LeadError) {
          return Center(child: Text("❌ ${state.message}"));
        }
        return const Center(child: Text("No data"));
      },
    );
  }
}