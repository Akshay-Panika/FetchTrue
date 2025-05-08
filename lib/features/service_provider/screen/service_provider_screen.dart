import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = const [
    Tab(text: 'Services'),
    Tab(text: 'Reviews'),
    Tab(text: 'About'),
    Tab(text: 'Gallery'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Provider',
        showBackButton: true,
        showFavoriteIcon: true,
      ),
      body: Column(
        children: [
          _ProfileCard(),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blueAccent,
            tabAlignment: TabAlignment.start,
            tabs: myTabs,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: myTabs.map((tab) {
                return Center(child: Text('${tab.text} Content'));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ProfileCard() {
    return CustomContainer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade100,
                child: const Icon(Icons.person),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provider Name',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      Text(
                        'Address :',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          CustomContainer(height: 50),
        ],
      ),
    );
  }
}
