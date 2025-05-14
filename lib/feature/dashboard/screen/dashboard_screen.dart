import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/costants/custom_color.dart';
import '../../academy/screen/academy_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../more/screen/more_screen.dart';
import '../../my_lead/screen/my_Lead_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int _selectedIndex = 0;
  final icons = const [
    Icons.home_outlined,
    Icons.bookmark_outline,
    Icons.video_collection_outlined,
    CupertinoIcons.profile_circled,
  ];


  final labels = const [
    'Home',
    'My Lead',
    'Academy',
    'Menu',
  ];


  final List<Widget> _screens = const [
    HomeScreen(),
    MyLeadScreen(),
    AcademyScreen(),
    MoreScreen(),
  ];
  List<int> _history = [0];

  @override
  Widget build(BuildContext context) {
    print('___________________________________ Build dashboard screen');

    return PopScope(
      canPop: _history.length == 1,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_history.length > 1) {
            _history.removeLast();
            setState(() => _selectedIndex = _history.last);
          } else {
            SystemNavigator.pop(); // app close
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
                _history.add(index);
                setState(() => _selectedIndex = index);
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: CustomColor.appColor,
            unselectedItemColor: CustomColor.iconColor,
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

