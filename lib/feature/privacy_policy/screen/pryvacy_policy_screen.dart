import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  final String htmlPara = """
    <h2 style="color: #2C3E50;">Privacy Policy for <strong>Fetch True</strong></h2>

    <p style="font-size: 16px; color: #555;">
      At <strong>Fetch True</strong>, we are committed to protecting your personal information and your right to privacy.
      This Privacy Policy describes how we collect, use, and handle your data when you use our services.
    </p>

    <h3 style="color: #34495E;">1. Information Collection</h3>
    <p style="font-size: 15px; color: #555;">
      We collect personal details such as your name, email, phone number, and other relevant information to enhance your experience.
    </p>

    <h3 style="color: #34495E;">2. How We Use Your Information</h3>
    <ul style="font-size: 15px; color: #555;">
      <li>🔐 To provide secure and seamless services</li>
      <li>📈 To analyze user engagement and improve our features</li>
      <li>📬 To communicate updates, offers, and support</li>
    </ul>

    <h3 style="color: #34495E;">3. Data Security</h3>
    <p style="font-size: 15px; color: #555;">
      We implement advanced security measures to safeguard your data and ensure its confidentiality and integrity.
    </p>

    <h3 style="color: #34495E;">4. Third-Party Access</h3>
    <p style="font-size: 15px; color: #555;">
      We do not share your data with third parties without your explicit consent, except as required by law.
    </p>

    <h3 style="color: #34495E;">5. Your Rights</h3>
    <p style="font-size: 15px; color: #555;">
      You have the right to access, modify, or delete your personal data at any time by contacting our support team.
    </p>

    <p style="font-size: 14px; color: #888;">Effective Date: January 1, 2025 | © Fetch True</p>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy & Policy', showBackButton: true),
      body: SafeArea(
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Privacy & Policy - Fetch True", style: textStyle16(context)),

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
