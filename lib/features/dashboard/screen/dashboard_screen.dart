import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../more/screen/more_screen.dart';
import '../../academy/screen/academy_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../my_lead/screen/my_Lead_screen.dart';
import '../bloc/bottom_nav_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

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
    MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    print('___________________________________ Build dashboard screen');
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return WillPopScope(
            onWillPop: () async {
              if (selectedIndex != 0) {
                //setState(() => selectedIndex = 0);
                context.read<NavigationCubit>().updateIndex(0);
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              body: IndexedStack(
                index: selectedIndex,
                children: _screens,
              ),

              bottomNavigationBar: SafeArea(
                child: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
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
        },
      ),
    );
  }
}

