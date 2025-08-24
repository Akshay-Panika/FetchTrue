import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/formate_price.dart';
import '../../my_lead/bloc/leads/leads_bloc.dart';
import '../../my_lead/bloc/leads/leads_event.dart';
import '../../my_lead/bloc/leads/leads_state.dart';
import '../../my_lead/widget/leads_details_widget.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_bloc.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_event.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_state.dart';
import '../model/my_team_model.dart';
import '../repository/upcoming_lead_commission_repository.dart';

class TeamLeadScreen extends StatelessWidget {
  final String userId;
  final List<dynamic> leadsData;
  const TeamLeadScreen({super.key, required this.userId, required this.leadsData});

  @override
  Widget build(BuildContext context) {

    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'completed':
          return Colors.green;
        case 'active':
          return Colors.blue;
        case 'pending':
          return Colors.orange;
        case 'cancelled':
          return Colors.red;
        default:
          return CustomColor.descriptionColor;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Lead', showBackButton: true,),

      body: BlocProvider(
        create: (_) => LeadsBloc()..add(FetchLeadsDataById(userId)),
        child: BlocBuilder<LeadsBloc, LeadsState>(
          builder: (context, state) {
            if (state is LeadsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LeadsLoaded) {
              final leads = state.checkouts;

              if (leads.isEmpty) {
                return  Center(
                  child: Column(
                    children: [
                      200.height,
                      Icon(Icons.leaderboard_outlined, size: 30,color: CustomColor.iconColor,),
                      Text("Is Empty."),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: leads.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  final data = leadsData.length > index ? leadsData[index] : null;
                  return CustomContainer(
                    border: true,
                    margin: const EdgeInsets.only(top: 10),
                    color: CustomColor.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text('${lead.service.serviceName}', style: textStyle12(context))),
                                Text(
                                  '[ ${lead.orderStatus} ]',
                                  style: textStyle12(context, color: getStatusColor(lead.orderStatus)),
                                ),
                              ],
                            ),
                            Text('Lead Id: ${lead.bookingId}', style: textStyle12(context, )),
                            5.height,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Amount: ', style: textStyle12(context)),
                                    10.width,
                                    CustomAmountText(amount: '${lead.service.price}', isLineThrough: true),
                                    10.width,
                                    // CustomAmountText(amount: '${formatPrice(lead.service.discountedPrice)}'),
                                  ],
                                ),

                                // Text(
                                //   (data.commissionEarned == 0 || data.commissionEarned == null)
                                //       ? 'Expected Earning: ₹ ${formatPrice(data.commissionEarned)}'
                                //       : 'Commission Earned: ₹ ${formatPrice(data.commissionEarned)}',
                                //   style: textStyle12(context, color: CustomColor.appColor),
                                // ),
                                BlocProvider(
                                  create: (_) => UpcomingLeadCommissionBloc(
                                    repository: UpcomingLeadCommissionRepository(),
                                  )..add(FetchUpcomingLeadCommission(lead.id)),
                                  child: BlocBuilder<UpcomingLeadCommissionBloc, UpcomingLeadCommissionState>(
                                    builder: (context, state) {
                                      if (state is UpcomingLeadCommissionLoading) {
                                        return const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        );
                                      } else if (state is UpcomingLeadCommissionLoaded) {
                                        final commission = state.commission.data;
                                        return Column(
                                          children: [

                                            if(data.commissionEarned == 0)
                                              Text("Expected Earning: ₹ ${formatPrice(commission.share1)}", style: textStyle12(context),),

                                            if(data.commissionEarned != 0)
                                              Text('Commission Earned: ₹ ${formatPrice(data.commissionEarned)}', style: textStyle12(context),),
                                          ],
                                        );
                                      } else if (state is UpcomingLeadCommissionError) {
                                        return Text('After Accepted Lead: ₹ __', style: textStyle12(context),);

                                        // return Center(child: Text("Error: ${state.message}"));
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                )

                              ],
                            ),
                            10.height,
                          ],
                        ),

                        DottedBorder(
                          padding: const EdgeInsets.all(15),
                          color: CustomColor.greyColor,
                          dashPattern: const [10, 5],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('Booking Date',
                                    style: textStyle14(context,fontWeight: FontWeight.w400),),
                                  Text(
                                    formatDateTime(DateTime.parse(lead.createdAt)),
                                    style: textStyle12(context, color: CustomColor.descriptionColor),)

                                ],
                              ),
                              Column(
                                children: [
                                  Text('Schedule Date',
                                    style: textStyle14(context,fontWeight: FontWeight.w400),),
                                  Text(
                                    lead.acceptedDate != null && lead.acceptedDate!.isNotEmpty
                                        ? formatDateTime(DateTime.parse(lead.acceptedDate!))
                                        : "No date schedule",
                                    style: textStyle12(context, color: CustomColor.descriptionColor),
                                  )


                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            if (state is LeadsError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      )
    );
  }
}

