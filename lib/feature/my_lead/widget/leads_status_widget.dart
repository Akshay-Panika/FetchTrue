import 'package:flutter/material.dart';

import '../model/lead_status_model.dart';
import '../repository/lead_service.dart';
import '../repository/lead_status_service.dart';

class LeadsStatusWidget extends StatefulWidget {
  final String checkoutId;
  const LeadsStatusWidget({super.key, required this.checkoutId});

  @override
  State<LeadsStatusWidget> createState() => _LeadsStatusWidgetState();
}

class _LeadsStatusWidgetState extends State<LeadsStatusWidget> {
  LeadStatusModel? leadData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeadStatus();
  }

  Future<void> fetchLeadStatus() async {
    final data = await LeadStatusService().fetchLeadStatusByCheckout(widget.checkoutId);
    setState(() {
      leadData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : leadData == null
        ? const Center(child: Text('No data found'))
        : ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: leadData!.leads.length,
      itemBuilder: (context, index) {
        final lead = leadData!.leads[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lead.statusType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  lead.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                if (lead.zoomLink.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.videocam, color: Colors.purple),
                      const SizedBox(width: 6),
                      Text("Zoom: ${lead.zoomLink}"),
                    ],
                  ),
                if (lead.paymentLink != null)
                  Row(
                    children: [
                      const Icon(Icons.payment, color: Colors.green),
                      const SizedBox(width: 6),
                      Text("Payment: ${lead.paymentType ?? ''}"),
                    ],
                  ),
                const SizedBox(height: 8),
                Text(
                  "Date: ${lead.createdAt.toLocal()}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
