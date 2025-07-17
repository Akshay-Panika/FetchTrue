import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../academy/screen/academy_screen.dart';
import '../../home/screen/home_screen.dart';
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
  final List<int> _history = [0];

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

  List<Widget> getScreens() {
    return const [
      HomeScreen(),
      MyLeadScreen(),
      OfferScreen(),
      AcademyScreen(),
      MoreScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions dimensions = Dimensions(context); // keep if used in future

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
          children: getScreens(),
        ),
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (_selectedIndex != index) {
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
