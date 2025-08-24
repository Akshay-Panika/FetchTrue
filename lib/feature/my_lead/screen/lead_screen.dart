import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lead/lead_bloc.dart';
import '../bloc/lead/lead_event.dart';
import '../bloc/lead/lead_state.dart';
import '../repository/lead_repository.dart';

class LeadsByUserScreen extends StatelessWidget {
  final String userId;

  const LeadsByUserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    context.read<LeadBloc>().add(FetchLeadsByUser(userId));

    return Scaffold(
      appBar: AppBar(title: const Text("Leads By User")),
      body: BlocBuilder<LeadBloc, LeadState>(
        builder: (context, state) {
          if (state is LeadLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LeadLoaded) {
            final leads = state.leadModel.data ?? [];
            return ListView.builder(
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return ListTile(
                  title: Text(lead.service?.serviceName ?? "No Service"),
                  subtitle: Text("User: ${lead.user ?? 'Unknown'}"),
                );
              },
            );
          } else if (state is LeadError) {
            return Center(child: Text("❌ ${state.message}"));
          }
          return const Center(child: Text("No data"));
        },
      ),
    );
  }
}
