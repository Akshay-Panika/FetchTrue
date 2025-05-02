import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

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
              child: SlidingToggleTabs(
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

class SlidingToggleTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int index) onTap;

  const SlidingToggleTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          // Animated sliding indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 1 / labels.length,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          // Label buttons
          Row(
            children: List.generate(labels.length, (index) {
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(5),
                  child: Center(
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
