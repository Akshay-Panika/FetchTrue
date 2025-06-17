
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

class CancellationPolicyScreen extends StatelessWidget {
  const CancellationPolicyScreen({super.key});

  final String htmlPara = """
    <h2 style="color: #2C3E50;">Cancellation Policy for <strong>Fetch True</strong></h2>

    <p style="font-size: 16px; color: #555;">
      At <strong>Fetch True</strong>, we understand that plans may change. This cancellation policy outlines the terms for cancelling a service.
    </p>

    <h3 style="color: #34495E;">1. Cancellation Requests</h3>
    <ul style="font-size: 15px; color: #555;">
      <li>📩 Cancellations must be requested via email or in-app support.</li>
      <li>📆 Requests must be made at least 24 hours before the scheduled service.</li>
    </ul>

    <h3 style="color: #34495E;">2. Refund on Cancellation</h3>
    <p style="font-size: 15px; color: #555;">
      If cancellation is approved within the allowed time frame, a full or partial refund may be granted as per our refund policy.
    </p>

    <h3 style="color: #34495E;">3. Late Cancellation</h3>
    <p style="font-size: 15px; color: #555;">
      Requests made after the cut-off time may not be eligible for a refund.
    </p>

    <h3 style="color: #34495E;">4. No-Show Policy</h3>
    <p style="font-size: 15px; color: #555;">
      Failure to appear for a scheduled service without prior notice will be treated as a no-show and is non-refundable.
    </p>

    <p style="font-size: 14px; color: #888;">Effective Date: January 1, 2025 | © Fetch True</p>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Cancellation Policy', showBackButton: true),
      body: SafeArea(
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cancellation Policy - Fetch True", style: textStyle16(context)),

                const Divider(),
                Html(data: htmlPara),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
