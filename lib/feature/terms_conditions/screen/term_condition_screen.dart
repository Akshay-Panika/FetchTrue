import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class TermConditionScreen extends StatelessWidget {
  const TermConditionScreen({super.key});

  final String htmlPara = """
    <h2 style="color: #2C3E50;">Terms & Conditions for <strong>Fetch True</strong></h2>

    <p style="font-size: 16px; color: #555;">
      By accessing or using <strong>Fetch True</strong>, you agree to be bound by these Terms and Conditions.
    </p>

    <h3 style="color: #34495E;">1. Acceptance of Terms</h3>
    <p style="font-size: 15px; color: #555;">
      Your use of our services implies acceptance of all terms and policies listed on this platform.
    </p>

    <h3 style="color: #34495E;">2. User Responsibilities</h3>
    <ul style="font-size: 15px; color: #555;">
      <li>✅ Provide accurate and updated information</li>
      <li>🚫 Do not misuse or abuse our services</li>
      <li>🔒 Maintain the confidentiality of your credentials</li>
    </ul>

    <h3 style="color: #34495E;">3. Modifications</h3>
    <p style="font-size: 15px; color: #555;">
      We reserve the right to update these terms at any time without prior notice. Please review them periodically.
    </p>

    <h3 style="color: #34495E;">4. Limitation of Liability</h3>
    <p style="font-size: 15px; color: #555;">
      Fetch True shall not be liable for any direct or indirect damages resulting from your use of our platform.
    </p>

    <p style="font-size: 14px; color: #888;">Effective Date: January 1, 2025 | © Fetch True</p>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Term & Condition', showBackButton: true),
      body: SafeArea(
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Term & Condition - Fetch True", style: textStyle16(context)),
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
