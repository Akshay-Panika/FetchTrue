import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_toggle_taps.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Service Details', showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            const CustomContainer(height: 200),
            const SizedBox(height: 20),

            // 🔥 Sliding Toggle Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomToggleTabs(
                labels: const ['Overview', 'Details'],
                selectedIndex: _selectedTabIndex,
                onTap: (index) {
                  setState(() => _selectedTabIndex = index);
                },
              ),
            ),

            const SizedBox(height: 10),

            // Content
            Expanded(
              child: CustomContainer(
                child: Center(
                  child: Text(
                    _selectedTabIndex == 0 ? 'Overview content here' : 'Details content here',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

