import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../model/lead_model.dart';
import '../model/leads_model.dart';

class LeadsDetailsWidget extends StatelessWidget {
  final LeadsModel lead;
  const LeadsDetailsWidget({super.key, required this.lead});

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    final parsed = DateTime.tryParse(date);
    return parsed == null ? 'Invalid Date' : DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
  }

  String _getLeadStatus() {
    if (lead.isCanceled == true) return 'Cancel';
    if (lead.isCompleted == true) return 'Completed';
    if (lead.isAccepted == true) return 'Accepted';
    return 'Pending';
  }

  Color _getStatusColor() {
    if (lead.isCanceled == true) return Colors.red;
    if (lead.isCompleted == true) return Colors.green;
    if (lead.isAccepted == true) return Colors.orange;
    return Colors.grey;
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
          ),
          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildInfoRow("Lead ID", lead.bookingId ?? 'N/A'),
              _buildInfoRow("Service", lead.service.serviceName),
              _buildInfoRow("Amount", "₹ ${lead.totalAmount.toString()}"),
              _buildInfoRow("Created At", _formatDate(lead.createdAt)),
              _buildInfoRow("Accepted Date", _formatDate(lead.acceptedDate)),
              _buildInfoRow("Status", _getLeadStatus()),
            ],
          ),
        ),
      ],
    );
  }
}
