import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/module/leads_bloc.dart';
import '../bloc/module/leads_event.dart';
import '../bloc/module/leads_state.dart';

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
              return const Center(child: CircularProgressIndicator());
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

              // 🔹 Final UI
              return Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip('All', allLeads.length),
                        _buildFilterChip('Pending', pendingLeads.length),
                        _buildFilterChip('Accepted', acceptedLeads.length),
                        _buildFilterChip('Completed', completedLeads.length),
                        _buildFilterChip('Cancel', cancelLeads.length),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: filteredList.isEmpty
                        ? const Center(child: Text('😕 No leads found.'))
                        : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Card(
                          child: ListTile(
                            title: Text("📌 ${item.bookingId}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("💵 Amount: ₹${item.totalAmount}"),
                                Text("📦 Order Status: ${item.orderStatus}"),
                                Text("💳 Payment: ${item.paymentStatus}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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

  Widget _buildFilterChip(String label, int count) {
    final isSelected = label == selectedFilter;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
      child: ChoiceChip(
        label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
        selectedColor: Colors.blue,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
