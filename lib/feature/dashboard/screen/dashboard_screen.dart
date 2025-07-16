import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';

import '../../academy/screen/academy_screen.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../home/screen/home_screen.dart';
import '../../more/model/user_model.dart';
import '../../more/screen/more_screen.dart';
import '../../my_lead/screen/my_Lead_screen.dart';
import '../../offer/screen/offer_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<IconData> icons = const [
    Icons.home_outlined,
    Icons.bookmark_outline,
    Icons.shopping_cart_outlined,
    Icons.video_collection_outlined,
    CupertinoIcons.profile_circled,
  ];

  final List<String> labels = const [
    'Home',
    'My Lead',
    'Offer',
    'Academy',
    'Menu',
  ];

  final List<int> _history = [0];

  @override
  void initState() {
    super.initState();
    userNotifier.addListener(_onUserUpdate);
  }

  @override
  void dispose() {
    userNotifier.removeListener(_onUserUpdate);
    super.dispose();
  }

  void _onUserUpdate() {
    setState(() {}); // Rebuild all screens that depend on userNotifier
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions dimensions = Dimensions(context);
    final user = userNotifier.value;
    final List<Widget> _screens = [
      HomeScreen(user: user),
      MyLeadScreen(),
      OfferScreen(),
      AcademyScreen(),
      const MoreScreen(),
    ];

    return PopScope(
      canPop: _history.length == 1, // true = allow system pop (exit app)
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_history.length > 1) {
            _history.removeLast(); // Remove current screen
            setState(() => _selectedIndex = _history.last); // Go to previous
          } else {
            SystemNavigator.pop(); // Exit app if only 1 item
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (_selectedIndex != index) {
                // Avoid duplicate history entry
                if (_history.isEmpty || _history.last != index) {
                  _history.add(index);
                }
                setState(() => _selectedIndex = index);
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: CustomColor.appColor,
            unselectedItemColor: CustomColor.descriptionColor,
            backgroundColor: Colors.white,
            elevation: 0.8,
            items: List.generate(icons.length, (index) {
              return BottomNavigationBarItem(
                icon: Icon(icons[index]),
                label: labels[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
