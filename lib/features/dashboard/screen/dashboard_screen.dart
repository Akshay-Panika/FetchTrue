import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../academy/screen/academy_screen.dart';
import '../../auth/screen/auth_screen.dart';
import '../../auth/screen/sign_in_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../more/screen/more_screen.dart';
import '../../my_lead/screen/my_Lead_screen.dart';
import '../bloc/bottom_nav_cubit.dart';

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
    AuthPage(),
  ];

  @override
  Widget build(BuildContext context) {
    print('___________________________________ Build dashboard screen');
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() => _selectedIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),

        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            // onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
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

