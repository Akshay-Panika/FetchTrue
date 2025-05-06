import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class LeadDetailsScreen extends StatelessWidget {
  const LeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: CustomAppBar(title: 'Lead Details', showBackButton: true),

        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Status'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDetailsTab(),
                  _buildStatusTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Center(
      child: Text('Lead details content goes here'),
    );
  }

  Widget _buildStatusTab() {
    return Center(
      child: Text('Lead status timeline or info goes here'),
    );
  }
}
