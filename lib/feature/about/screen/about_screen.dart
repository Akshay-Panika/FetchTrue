import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final String htmlPara = """
  <h2 style="color: #2C3E50;">Welcome to <strong>Fetch True</strong></h2>
  <p style="font-size: 16px; color: #555;">
    <strong>Fetch True</strong> is a modern business management solution designed to simplify your operations, boost productivity, and empower data-driven decisions.
  </p>
  <p style="font-size: 15px; color: #555;">
    Whether you're running a startup or a growing enterprise, Fetch True offers powerful tools to help you manage teams, monitor performance, and stay ahead in the competitive market.
  </p>

  <h3 style="color: #34495E;">Key Features:</h3>
  <ul style="font-size: 15px; color: #555;">
    <li>📊 Real-time analytics and reporting</li>
    <li>✅ Smart attendance and leave management</li>
    <li>🔐 Secure data handling and cloud storage</li>
    <li>📅 Custom dashboards and calendar integration</li>
    <li>🌐 Multi-language support (English, Hindi, Marathi)</li>
  </ul>

  <p style="font-size: 15px; color: #555;">
    Our mission is to empower businesses with tools that are easy to use, customizable, and scalable — all packed into a single, intuitive platform.
  </p>

  <p style="font-size: 14px; color: #888;">Version 1.0.0 | © 2025 Fetch True</p>
""";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'About', showBackButton: true),
      body: SafeArea(
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About Fetch True,", style: textStyle16(context)),
                10.height,
                Html(data: htmlPara), // ✅ Show HTML
              ],
            ),
          ),
        ),
      ),
    );
  }
}
