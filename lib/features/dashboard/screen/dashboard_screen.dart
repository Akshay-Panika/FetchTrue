import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../more/screen/more_screen.dart';
import '../../academy/screen/academy_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../my_lead/screen/my_Lead_screen.dart';
import '../bloc/bottom_nav_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final icons = const [
    Icons.home_outlined,
    Icons.insert_drive_file_outlined,
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
    MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    print('___________________________________ Build dashboard screen');
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(

            /// Using IndexedStack for better performance
            body: IndexedStack(
              index: selectedIndex,
              children: _screens,
            ),

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: List.generate(icons.length, (index) {
                return BottomNavigationBarItem(
                  icon: Icon(icons[index]),
                  label: labels[index],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

