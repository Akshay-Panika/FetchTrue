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
import '../model/my_team_model.dart';
import '../widget/team_card_widget.dart';

class TeamLeadsScreen extends StatelessWidget {
  final User member;
  final String earning;
  const TeamLeadsScreen({super.key, required this.member, required this.earning});

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

            _MemberLeads(),
          ],
        ),
      ),
    );
  }
}

class _MemberLeads extends StatelessWidget {
  const _MemberLeads({super.key});

  @override
  Widget build(BuildContext context) {
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
                          Text('Status: [ ${leads.orderStatus} ]', style: textStyle12(context, fontWeight: FontWeight.w400),),
                          10.height,
            
                          DottedBorder(
                            color: CustomColor.appColor,
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(8),
                            dashPattern: [6, 3],
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
                                      Text('${formatDateTime(leads.isAccepted)}',style: textStyle12(context, fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
            
                      Positioned(
                          right: 0,top: 0,
                          child: Text('Earning\nOpportunity ₹ 00', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),textAlign: TextAlign.end,))
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