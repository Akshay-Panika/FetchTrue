import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../academy/screen/academy_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../more/screen/more_screen.dart';
import '../../my_lead/screen/lead_screen.dart';
import '../../offer/screen/offers_screen.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LeadScreen(),
    OffersScreen(),
    AcademyScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          } else {
            SystemNavigator.pop(); // Exit app on Home tab
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: CustomColor.appColor,
            unselectedItemColor: CustomColor.iconColor,
            backgroundColor: Colors.white,
            elevation: 0.8,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Leads"),
              BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Offers"),
              BottomNavigationBarItem(icon: Icon(Icons.school), label: "Academy"),
              BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
            ],
          ),
        ),
      ),
    );
  }
}
