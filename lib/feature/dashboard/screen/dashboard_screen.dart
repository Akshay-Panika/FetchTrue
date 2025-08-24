import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../academy/screen/academy_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../more/screen/more_screen.dart';
import '../../my_lead/screen/lead_screen.dart';
import '../../my_lead/screen/leads_screen.dart';
import '../../offer/screen/offers_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<int> _history = [0];

  final List<IconData> icons = const [
    Icons.home_outlined,
    Icons.leaderboard_outlined,
    Icons.local_offer_outlined,
    Icons.school_outlined,
    CupertinoIcons.profile_circled,
  ];

  final List<String> labels = const [
    'Home',
    'My Lead',
    'Offer',
    'Academy',
    'Menu',
  ];

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = _generateScreens();
  }

  List<Widget> _generateScreens() {
    return [
      const HomeScreen(),
      LeadsScreen(key: UniqueKey()),
      const LeadsByUserScreen(userId: '689f4d1bd81bd14f1fb67674',),
      const AcademyScreen(),
      const MoreScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      if (_history.isEmpty || _history.last != index) {
        _history.add(index);
      }

      if (index == 1) {
        setState(() {
          _screens[1] = LeadsScreen(key: UniqueKey()); // force rebuild My Lead
          _selectedIndex = index;
        });
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions(context); // Initialize dimensions if needed

    return PopScope(
      canPop: _history.length == 1,
      onPopInvoked: (didPop) {
        if (!didPop && _history.length > 1) {
          _history.removeLast();
          setState(() => _selectedIndex = _history.last);
        } else if (_history.length == 1) {
          SystemNavigator.pop();
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
            onTap: _onItemTapped,
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