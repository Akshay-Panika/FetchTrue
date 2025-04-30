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
    Icons.dashboard_outlined,
  ];

  final labels = const [
    'Home',
    'My Lead',
    'Academy',
    'More',
  ];

  final List<Widget> _screens = const [
    HomeScreen(),
    MyLeadScreen(),
    AcademyScreen(),
    MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    print('___________________________________ Build Home screen');
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).cardColor,
              surfaceTintColor: Theme.of(context).cardColor,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(Icons.dashboard, color: Colors.black54,),
              ),
              leadingWidth: 40,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("BizBooster2x"),
                  const Text("Waidhan Singrauli Mp", style: TextStyle(fontSize: 12,color: Colors.grey),),
                ],
              ),
              titleTextStyle: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500),
              
              actions: [
                IconButton(onPressed: (){}, icon: Icon(Icons.notifications_active_outlined)),
                IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined)),
                SizedBox(width: 8,)
              ],
            ),

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

