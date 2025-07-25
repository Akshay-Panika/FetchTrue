import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/my_lead/model/leads_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/module/leads_bloc.dart';
import '../bloc/module/leads_event.dart';
import '../bloc/module/leads_state.dart';
import '../model/lead_model.dart';
import 'lead_details_screen.dart';
import 'leads_details_screen.dart';

class LeadsScreen extends StatefulWidget {
  final String? isBack;
  const LeadsScreen({super.key, this.isBack});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final List<String> filters = ['All', 'Pending', 'Accepted', 'Completed', 'Cancel'];
  String selectedFilter = 'All';
  LeadsBloc? leadsBloc;
  String? userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userSession = Provider.of<UserSession>(context);
    userId = userSession.userId;

    if (userId != null) {
      leadsBloc = LeadsBloc();
      leadsBloc!.add(FetchLeadsDataById(userId!));
    }
  }

  @override
  void dispose() {
    leadsBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'My Leads',
          showBackButton: widget.isBack == 'isBack',
          showNotificationIcon: true,
        ),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Leads',
        showBackButton: widget.isBack == 'isBack',
        showNotificationIcon: true,
      ),
      body: BlocProvider(
        create: (_) => leadsBloc!,
        child: BlocBuilder<LeadsBloc, LeadsState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return _buildShimmer();
            }
            else if (state is CheckoutLoaded) {
              final allLeads = state.checkouts;

              // 🔹 Filter Logic
              final pendingLeads = allLeads.where((e) =>
              e.isAccepted == false && e.isCompleted == false &&
                  e.isCanceled == false
              ).toList();

              final acceptedLeads = allLeads.where((e) => e.isAccepted == true && e.isCompleted == false && e.isCanceled == false).toList();

              final completedLeads = allLeads.where((e) => e.isCompleted == true).toList();

              final cancelLeads = allLeads.where((e) => e.isCanceled == true).toList();

              // 🔹 Filtered List According to Tab
              List filteredList;
              switch (selectedFilter) {
                case 'Pending':
                  filteredList = pendingLeads;
                  break;
                case 'Accepted':
                  filteredList = acceptedLeads;
                  break;
                case 'Completed':
                  filteredList = completedLeads;
                  break;
                case 'Cancel':
                  filteredList = cancelLeads;
                  break;
                default:
                  filteredList = allLeads;
              }

              /// 🔹 Final UI
              return  CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                      toolbarHeight: 30,
                      backgroundColor: CustomColor.whiteColor,
                     flexibleSpace: FlexibleSpaceBar(
                 background: ListView(
                   scrollDirection: Axis.horizontal,
                   children: [
                     _buildFilterChip('All', allLeads.length),
                     _buildFilterChip('Pending', pendingLeads.length),
                     _buildFilterChip('Accepted', acceptedLeads.length),
                     _buildFilterChip('Completed', completedLeads.length),
                     _buildFilterChip('Cancel', cancelLeads.length),
                   ],
                 ),),
                  ),

                  SliverToBoxAdapter(
                    child:  filteredList.isEmpty
                        ? Padding(
                        padding: EdgeInsetsGeometry.only(top: 300),
                        child: const Center(child: Text('No leads.')))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        final lead = filteredList[index];


                        return CustomContainer(
                          backgroundColor: Colors.white,
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(lead.service.serviceName, style: textStyle14(context)),
                                  Text(
                                    '[ ${getLeadStatus(lead)} ]',
                                    style: textStyle12(context, fontWeight: FontWeight.bold, color: getStatusColor(lead)),
                                  )
                                ],
                              ),
                              Text('Lead Id: ${lead.bookingId}', style: textStyle12(context, color: CustomColor.descriptionColor)),
                              const Divider(),
                              5.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Booking Date:  ${formatDate(lead.createdAt)}', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                                      Text('Service Date:  ${formatDate(lead.acceptedDate)}', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Amount", style: textStyle12(context, fontWeight: FontWeight.w500)),
                                      CustomAmountText(amount: '${lead.totalAmount}'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeadsDetailsScreen(
                            leadName: lead.service.serviceName,
                            lead: lead,
                          ),)),
                        );
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20,),)
                ],
              );
            }

            else if (state is CheckoutError) {
              return Center(child: Text('❌ ${state.message}'));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }


  /// Filter
  Widget _buildFilterChip(String label, int count) {
    final isSelected = label == selectedFilter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () {
        setState(() {
          selectedFilter = label;
        });
      }, child: Text(
        '$label ($count)',
        style: TextStyle(
          color: isSelected ? CustomColor.appColor : CustomColor.blackColor,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),),
    );
  }

  /// Format Date
  String formatDate(String? rawDate) {
    if (rawDate == null) return 'N/A';
    final date = DateTime.tryParse(rawDate);
    if (date == null) return 'Invalid Date';
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Lead Status
  String getLeadStatus(lead) {
    if (lead.isCanceled == true) return 'Cancel';
    if (lead.isCompleted == true) return 'Completed';
    if (lead.isAccepted == true) return 'Accepted';
    return 'Pending';
  }

  /// Status Color
  Color getStatusColor(lead) {
    if (lead.isCanceled == true) return Colors.red;
    if (lead.isCompleted == true) return Colors.green;
    if (lead.isAccepted == true) return Colors.orange;
    return Colors.grey;
  }

}




Widget _buildShimmer() {
  return Column(
    children: [
      Container(
        color: CustomColor.whiteColor,
        padding: EdgeInsetsGeometry.only(bottom: 10),
        child: Row(children: List.generate(4, (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ShimmerBox(height: 14,width: 80,)),
        ),),),
      ),
      Expanded(
        child: ListView(
          children: List.generate(
            6, (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomContainer(
              backgroundColor: CustomColor.whiteColor,
              margin: EdgeInsetsGeometry.only(top: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(height: 14, width: 120),
                        ShimmerBox(height: 14, width: 60),
                      ],
                    ),
                    5.height,
                    const ShimmerBox(height: 12, width: 180),
                    5.height,
                    const Divider(),
                    10.height,
                    // Dates & Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(height: 12, width: 140),
                            5.height,
                            ShimmerBox(height: 12, width: 140),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShimmerBox(height: 12, width: 60),
                            5.height,
                            ShimmerBox(height: 14, width: 70),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    ],
  );
}

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

