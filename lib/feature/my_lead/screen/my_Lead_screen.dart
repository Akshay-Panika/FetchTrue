import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/module/lead_bloc.dart';
import '../bloc/module/lead_event.dart';
import '../bloc/module/lead_state.dart';
import '../model/lead_model.dart';
import '../repository/lead_service.dart';
import 'lead_details_screen.dart';

class MyLeadScreen extends StatefulWidget {
  final String? isBack;
  const MyLeadScreen({super.key, this.isBack});

  @override
  State<MyLeadScreen> createState() => _MyLeadScreenState();
}

class _MyLeadScreenState extends State<MyLeadScreen> {


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'My Leads',
        showBackButton: widget.isBack =='isBack'?true:false, showNotificationIcon: true,),

      body: SafeArea(
        child:  CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight*0.01,),),

            /// Filter
            SliverAppBar(
              floating: true,
              toolbarHeight: 40,
              backgroundColor: CustomColor.canvasColor,
              flexibleSpace: FlexibleSpaceBar(
                background:  _buildFilterChips(),
              ),
            ),


            SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight*0.005,),),

            SliverToBoxAdapter(
              child:  BlocProvider(
                create: (_) => LeadBloc(LeadService())..add(GetLead()),
                child:  BlocBuilder<LeadBloc, LeadState>(
                  builder: (context, state) {
                    if (state is LeadLoading) {
                      return LinearProgressIndicator(
                        backgroundColor: CustomColor.appColor,
                        color: Colors.white,
                        minHeight: 2.5,
                      );
                    }
                    else if(state is LeadLoaded){
                      final lead = state.leadModel;


                      if (lead.isEmpty) {
                        return const Center(child: Text('No modules found.'));
                      }

                      return ListView.builder(
                        itemCount: lead.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                        final data = lead[index];
                        return _buildBookingCard(dimensions: dimensions, lead: data);
                      },);
                    }

                    else if (state is LeadError) {
                      return Center(child: Text(state.errorMessage));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String isSelected = 'All';
  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Accepted', 'Ongoing', 'Completed'];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      itemCount: filters.length,
      itemBuilder: (context, index) {
        final filter = filters[index];
        final bool selected = filter == isSelected;

        return CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Text(
              filter,
              style: textStyle14(
                context,
                color: selected ? Colors.blueAccent : Colors.black87,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          onTap: () {
            setState(() {
              isSelected = filter;
            });
          },
        );
      },
    );
  }

  Widget _buildBookingCard({required Dimensions dimensions, required LeadModel lead}) {

    return CustomContainer(
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeadDetailsScreen(lead: lead,),)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lead.service.serviceName,
                style:  textStyle14(context),
              ),

              widget.isBack =='isBack'?
              _buildStatusBadge('Completed'):
              _buildStatusBadge('Pending'),
            ],
          ),
          Text('Lead Id: ${lead.bookingId}', style:  textStyle12(context,color: CustomColor.descriptionColor),),
          Divider(),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking Date: ${DateFormat('dd-MM-yyyy, hh:mm a').format(DateTime.parse(lead.createdAt))}',style:  textStyle12(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                  Text('Service Date : ', style: textStyle12(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Amount",style: textStyle12(context, fontWeight: FontWeight.w500),),
                  CustomAmountText(amount:  lead.service.discountedPrice.toString()),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == 'Pending') color = Colors.orange;
    if (status == 'Accepted') color = Colors.green;
    if (status == 'Ongoing') color = Colors.blue;
    if (status == 'Cancel') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(5),
        color: color.withOpacity(0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          5.width,
          Text(
            status, style: textStyle12(context, color: color,),),
        ],
      ),
    );
  }
}
