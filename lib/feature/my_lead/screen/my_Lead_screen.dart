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
  late LeadBloc _leadBloc;
  String isSelected = 'All';

  @override
  void initState() {
    super.initState();
    _leadBloc = LeadBloc(LeadService())..add(GetLead());
  }

  @override
  void dispose() {
    _leadBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Leads',
        showBackButton: widget.isBack == 'isBack',
        showNotificationIcon: true,
      ),
      body: SafeArea(
        child: BlocProvider.value(
          value: _leadBloc,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight * 0.01)),
              SliverAppBar(
                floating: true,
                toolbarHeight: 40,
                backgroundColor: CustomColor.canvasColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildFilterChips(),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight * 0.005)),
              SliverToBoxAdapter(
                child: BlocBuilder<LeadBloc, LeadState>(
                  builder: (context, state) {
                    if (state is LeadLoading) {
                      return LinearProgressIndicator(
                        backgroundColor: CustomColor.appColor,
                        color: Colors.white,
                        minHeight: 2.5,
                      );
                    } else if (state is LeadLoaded) {
                      final allLeads = state.leadModel;
                      List<LeadModel> filteredLeads = allLeads;

                      if (isSelected != 'All') {
                        filteredLeads = allLeads.where((lead) {
                          final paymentStatus = (lead.paymentStatus ?? '').toLowerCase();
                          final orderStatus = (lead.orderStatus ?? '').toLowerCase();

                          switch (isSelected) {
                            case 'Pending':
                              return lead.isAccepted == false && paymentStatus == 'pending';
                            case 'Accepted':
                              return lead.isAccepted == true;
                            case 'Ongoing':
                              return orderStatus == 'ongoing';
                            case 'Completed':
                              return orderStatus == 'completed';
                            case 'Cancel':
                              return orderStatus == 'cancel';
                            default:
                              return true;
                          }
                        }).toList();
                      }

                      if (filteredLeads.isEmpty) {
                        return const Center(child: Text('No modules found.'));
                      }

                      return ListView.builder(
                        itemCount: filteredLeads.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = filteredLeads[index];
                          return _buildBookingCard(dimensions: dimensions, lead: data);
                        },
                      );
                    } else if (state is LeadError) {
                      return Center(child: Text(state.errorMessage));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Accepted', 'Ongoing', 'Completed', 'Cancel'];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            _leadBloc.add(GetLead());
          },
        );
      },
    );
  }

  Widget _buildBookingCard({required Dimensions dimensions, required LeadModel lead}) {
    String bookingDate = 'Invalid date';
    try {
      bookingDate = DateFormat('dd-MM-yyyy, hh:mm a').format(DateTime.parse(lead.createdAt));
    } catch (e) {}

    String formattedServiceDate = 'N/A';
    try {
      if (lead.acceptedDate != null && lead.acceptedDate!.isNotEmpty) {
        formattedServiceDate = DateFormat('dd-MM-yyyy, hh:mm a').format(DateTime.parse(lead.acceptedDate!));
      }
    } catch (e) {}

    return CustomContainer(
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeadDetailsScreen(lead: lead)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lead.service.serviceName, style: textStyle14(context)),
              _buildStatusBadge(lead),
            ],
          ),
          Text('Lead Id: ${lead.bookingId}', style: textStyle12(context, color: CustomColor.descriptionColor)),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking Date: $bookingDate', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                  Text('Service Date: $formattedServiceDate', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Amount", style: textStyle12(context, fontWeight: FontWeight.w500)),
                  CustomAmountText(amount: lead.service.discountedPrice.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(LeadModel lead) {
    String statusText = 'Unknown';
    Color color = Colors.grey;

    if (lead.isAccepted == true) {
      statusText = 'Accepted';
      color = Colors.green;
    } else {
      final status = lead.paymentStatus.toLowerCase();
      statusText = capitalize(status);
      if (status == 'pending') color = Colors.orange;
      if (status == 'ongoing') color = Colors.blue;
      if (status == 'cancel') color = Colors.red;
      if (status == 'completed') color = Colors.green;
    }

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
          const SizedBox(width: 5),
          Text(statusText, style: textStyle12(context, color: color)),
        ],
      ),
    );
  }

  String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}
