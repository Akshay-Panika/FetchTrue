import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  final String htmlPara = """
    <h2 style="color: #2C3E50;">Refund Policy for <strong>Fetch True</strong></h2>

    <p style="font-size: 16px; color: #555;">
      At <strong>Fetch True</strong>, customer satisfaction is our top priority. This refund policy outlines the terms under which refunds are processed.
    </p>

    <h3 style="color: #34495E;">1. Eligibility for Refunds</h3>
    <p style="font-size: 15px; color: #555;">
      Refunds are applicable under the following conditions:
    </p>
    <ul style="font-size: 15px; color: #555;">
      <li>💳 Service not delivered as promised</li>
      <li>📅 Request made within 7 days of purchase</li>
      <li>📩 Proof of transaction must be provided</li>
    </ul>

    <h3 style="color: #34495E;">2. Non-Refundable Cases</h3>
    <p style="font-size: 15px; color: #555;">
      Refunds will not be issued for:
    </p>
    <ul style="font-size: 15px; color: #555;">
      <li>⏱ Services already used or consumed</li>
      <li>📉 Change of mind after service initiation</li>
      <li>📂 Misuse or breach of terms</li>
    </ul>

    <h3 style="color: #34495E;">3. Refund Process</h3>
    <p style="font-size: 15px; color: #555;">
      Once your request is approved, refunds will be processed within 5–10 business days through your original payment method.
    </p>

    <p style="font-size: 14px; color: #888;">Effective Date: January 1, 2025 | © Fetch True</p>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Refund Policy', showBackButton: true),
      body: SafeArea(
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Refund Policy - Fetch True", style: textStyle16(context)),

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
