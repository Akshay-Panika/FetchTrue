import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final List<Map<String, dynamic>> allBookings = [
    {
      'id': '100300',
      'bookingDate': '30 Apr,2025 06:16 PM',
      'serviceDate': '30 Apr,2025 06:15 AM',
      'status': 'Completed',
      'amount': '24,999.00'
    },
    {
      'id': '100299',
      'bookingDate': '30 Apr,2025 04:42 PM',
      'serviceDate': '30 Apr,2025 04:42 AM',
      'status': 'Completed',
      'amount': '49,999.00'
    },
    {
      'id': '100298',
      'bookingDate': '30 Apr,2025 02:08 PM',
      'serviceDate': '30 Apr,2025 02:08 AM',
      'status': 'Pending',
      'amount': '5,999.00'
    },
    {
      'id': '100297',
      'bookingDate': '30 Apr,2025 12:26 PM',
      'serviceDate': '30 Apr,2025 12:26 PM',
      'status': 'Accepted',
      'amount': '9,999.00'
    },
    {
      'id': '100296',
      'bookingDate': '30 Apr,2025 10:00 AM',
      'serviceDate': '30 Apr,2025 11:00 AM',
      'status': 'Ongoing',
      'amount': '19,999.00'
    },
    {
      'id': '100297',
      'bookingDate': '30 Apr,2025 12:26 PM',
      'serviceDate': '30 Apr,2025 12:26 PM',
      'status': 'Accepted',
      'amount': '9,999.00'
    },
  ];

  String selectedFilter = 'All';

  List<Map<String, dynamic>> get filteredBookings {
    if (selectedFilter == 'All') return allBookings;
    return allBookings.where((b) => b['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'My Leads',
        showBackButton: widget.isBack =='isBack'?true:false, showNotificationIcon: true,),

      body: SafeArea(
        child: BlocProvider(
          create: (_) => LeadBloc(LeadService())..add(GetLead()),
          child:  BlocBuilder<LeadBloc, LeadState>(
            builder: (context, state) {
              if (state is LeadLoading) {
                return LinearProgressIndicator();
              }
              else if(state is LeadLoaded){
                final lead = state.leadModel;
                // final lead = state.moduleModel .where((module) => module.categoryCount != 0)
                //     .toList();

                if (lead.isEmpty) {
                  return const Center(child: Text('No modules found.'));
                }

                return  Column(
                  children: [
                    SizedBox(height: dimensions.screenHeight*0.015),

                    /// filter
                    _buildFilterChips(),
                    SizedBox(height: dimensions.screenHeight*0.015),

                    Expanded(
                      child: ListView.builder(
                        itemCount: lead.length,
                        // itemCount: filteredBookings.length,
                        padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03,),
                        itemBuilder: (context, index) {
                          final data = lead[index];
                          return _buildBookingCard(dimensions: dimensions, lead: data);
                        },
                      ),
                    ),
                  ],
                );
              }

              else if (state is ModuleError) {
                return Center(child: Text(state.errorMessage));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Accepted', 'Ongoing', 'Completed'];

    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFilter == filters[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filters[index];
              });
            },
            child: CustomContainer(
              backgroundColor: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
             // color: isSelected ? Colors.blueAccent : Colors.white,
              child: Center(
                child: Text(
                  filters[index],
                  style: textStyle12(context,
                    color: isSelected ? Colors.blueAccent : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard({required Dimensions dimensions, required LeadModel lead}) {

    return CustomContainer(
      border: false,
      backgroundColor: Colors.white,
      margin: EdgeInsets.only(bottom: dimensions.screenHeight*0.015),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeadDetailsScreen(),)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lead.service.serviceName,
                style:  textStyle14(context),
              ),

              _buildStatusBadge('${lead.paymentStatus}'),
            ],
          ),
          Text('Lead id: #${lead.bookingId}', style:  textStyle12(context,color: CustomColor.descriptionColor),),

          Text('Booking Date : ${lead.createdAt}',style:  textStyle12(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
          Text('Service Date : ${lead.createdAt}', style: textStyle12(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
           SizedBox(height: dimensions.screenHeight*0.005),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Text("Amount :",style: textStyle12(context, fontWeight: FontWeight.w400),),
                  SizedBox(width: dimensions.screenWidth*0.01),
                  CustomAmountText(amount:  '${lead.service.discountedPrice}'),
                ],
              ),
              Text("Cashback : ${'00'}",style: textStyle12(context, fontWeight: FontWeight.w400),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == 'Completed') color = Colors.green;
    if (status == 'pending') color = Colors.orange;
    if (status == 'Accepted') color = Colors.purple;
    if (status == 'Ongoing') color = Colors.blue;

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
