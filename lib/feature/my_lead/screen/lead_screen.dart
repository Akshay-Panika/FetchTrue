import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/lead/lead_bloc.dart';
import '../bloc/lead/lead_event.dart';
import '../bloc/lead/lead_state.dart';
import '../widget/leads_details_widget.dart';
import 'leads_details_screen.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {

  final List<String> filters = ['All', 'Pending', 'Accepted', 'Completed', 'Cancel'];
  String selectedFilter = 'All';

  String? lastUserId;
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userSession = Provider.of<UserSession>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userSession.isLoggedIn && userSession.userId != lastUserId) {
        lastUserId = userSession.userId;
        context.read<LeadBloc>().add(FetchLeadsByUser(lastUserId!));
      } else if (!userSession.isLoggedIn) {
        lastUserId = null;
        context.read<LeadBloc>().add(ClearLeadData());
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Leads',),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title:'Leads'),

      body: BlocBuilder<LeadBloc, LeadState>(
        builder: (context, state) {
          if (state is LeadLoading) {
            return _buildShimmer();
          } else if (state is LeadLoaded) {
            // final allLeads = state.leadModel.data ?? [];
            final allLeads = (state.leadModel.data ?? [])
              ..sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));

            // Filter Logic
            final pendingLeads = allLeads.where((e) => e.isAccepted == false && e.isCompleted == false && e.isCanceled == false).toList();

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
                        color: Colors.white,
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
                                    Text('Booking Date:  ${formatDateTime(lead.createdAt)}', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                                    Text('Schedule Date:  ${formatDateTime(lead.acceptedDate)}', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Amount", style: textStyle12(context, fontWeight: FontWeight.w500)),
                                    CustomAmountText(amount: '${formatPrice(lead.totalAmount)}'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeadsDetailsScreen(
                          leadName: lead.service.serviceName,
                          leadId: lead.id,
                        ),)),
                      );
                    },
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 20,),)
              ],
            );

          } else if (state is LeadError) {
            return Center(child: Text("❌ ${state.message}"));
          }
          return const Center(child: Text("No data"));
        },
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
              color: CustomColor.whiteColor,
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

