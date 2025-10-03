import 'package:fetchtrue/core/costants/custom_image.dart';
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
import '../../internet/network_wrapper_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
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

    Dimensions dimensions = Dimensions(context);

    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Leads',),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return NetworkWrapper(
      child: Scaffold(
        appBar: CustomAppBar(title:'Leads'),
      
        body:  BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is UserInitial || userState is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userState is UserError) {
                debugPrint('Error: ${userState.massage}');
              }
            if(userState is UserLoaded){

              final user = userState.user;
              return BlocBuilder<LeadBloc, LeadState>(
                builder: (context, state) {
                  if (state is LeadLoading) {
                    return _buildShimmer();
                  }
                  else if (state is LeadLoaded) {

                    return  CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          toolbarHeight: dimensions.screenHeight * 0.035,
                          backgroundColor: CustomColor.whiteColor,
                          flexibleSpace: FlexibleSpaceBar(
                            background: ListView(
                              scrollDirection: Axis.horizontal,
                              children: filters
                                  .map((filter) => _buildFilterChip(context, filter, state))
                                  .toList(),
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child:   state.filteredLeads.isEmpty
                              ? Padding(
                              padding: EdgeInsetsGeometry.only(top: 280),
                              child:  Center(child: Column(
                                children: [
                                  Image.asset(CustomImage.emptyCart, height: 80,),
                                  Text('No leads.'),
                                ],
                              )))
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.filteredLeads.length,
                            padding: EdgeInsetsGeometry.symmetric(horizontal: dimensions.screenHeight*0.010),
                            itemBuilder: (context, index) {
                              final lead = state.filteredLeads[index];

                              return CustomContainer(
                                color: Colors.white,
                                margin: EdgeInsets.only(top: dimensions.screenHeight*0.010),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(lead.service!.serviceName.toString(), style: textStyle12(context, fontWeight: FontWeight.w400))),
                                        Text(
                                          '[ ${getLeadStatus(lead)} ]',
                                          style: textStyle12(context, color: getStatusColor(lead),fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    Text('Lead Id: ${lead.bookingId}', style: textStyle12(context, color: CustomColor.descriptionColor,fontWeight: FontWeight.w400)),
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
                                            CustomAmountText(amount: '${lead.totalAmount!.toStringAsFixed(2)}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeadsDetailsScreen(
                                  leadName: lead.service!.serviceName,
                                  leadId: lead.id.toString(),
                                  user: user,
                                ),)),
                              );
                            },
                          ),
                        ),

                        SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight*0.020,),)
                      ],
                    );

                  }
                  else if (state is LeadError) {
                    print("❌ ${state.message}");
                    return Padding(
                        padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                        child:  Center(child: Column(
                          children: [
                            Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                            Text('No leads.'),
                          ],
                        )));
                  }
                  return Padding(
                      padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                      child:  Center(child: Column(
                        children: [
                          Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                          Text('No leads.'),
                        ],
                      )));
                },
              );
            }

              return SizedBox.shrink();

          }
        ),
      ),
    );
  }


  /// Filter
  Widget _buildFilterChip(BuildContext context, String label, LeadLoaded state) {
    final isSelected = label == state.selectedFilter;
    int count;
    switch (label) {
      case 'Pending':
        count = state.allLeads
            .where((e) =>
        !(e.isAccepted ?? false) &&
            !(e.isCompleted ?? false) &&
            !(e.isCanceled ?? false))
            .length;
        break;
      case 'Accepted':
        count = state.allLeads
            .where((e) =>
        (e.isAccepted ?? false) &&
            !(e.isCompleted ?? false) &&
            !(e.isCanceled ?? false))
            .length;
        break;
      case 'Completed':
        count =
            state.allLeads.where((e) => (e.isCompleted ?? false)).length;
        break;
      case 'Cancel':
        count = state.allLeads.where((e) => (e.isCanceled ?? false)).length;
        break;
      default:
        count = state.allLeads.length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () =>
            context.read<LeadBloc>().add(FilterLeads(label)),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: isSelected ? CustomColor.appColor : CustomColor.blackColor,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
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

