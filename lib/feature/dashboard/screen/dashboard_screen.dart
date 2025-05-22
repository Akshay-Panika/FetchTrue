import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/feature/package/screen/package_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../academy/screen/academy_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../home/screen/initial_home_screen.dart';
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
  final icons = const [
    Icons.home_outlined,
    Icons.bookmark_outline,
    Icons.shopping_cart_outlined,
    Icons.video_collection_outlined,
    CupertinoIcons.profile_circled,
  ];
  final labels = const [
    'Home',
    'My Lead',
    'Offer',
    'Academy',
    'Menu',
  ];
  final List<Widget> _screens = const [
    InitialHomeScreen(),
    MyLeadScreen(),
    OfferScreen(),
    AcademyScreen(),
    MoreScreen(),
  ];
  List<int> _history = [0];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => Container(
          height: 400,
          decoration:BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
            color: CustomColor.whiteColor,
          ) ,
          padding:  EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))),
              Column(
               crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text(
                    '🎉 Welcome Offer!',
                    style: textStyle18(context, color: CustomColor.appColor),
                  ),
                  30.height,
                  _buildAssuranceSection(context),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {

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

Widget _buildAssuranceSection(BuildContext context) {
  return CustomContainer(
    border: true,
    backgroundColor: CustomColor.whiteColor,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Image.asset('assets/package/packageBuyImg.png',)),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'We assure you  ',
                          style: textStyle14(context)),
                      TextSpan(
                        text: '5X Return ',
                        style: textStyle16(context,
                            color: CustomColor.appColor),
                      ),
                    ]),
                  ),
                  10.height,
                  Text(
                    'If you earn less than our assured earnings, we’ll refund up to 5X your initial amount',
                    style: textStyle12(context,
                        color: CustomColor.descriptionColor),
                    textAlign: TextAlign.right,
                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomAmountText(amount: '7,00,000', fontSize: 16,fontWeight: FontWeight.w500,),
                      10.width,
                      CustomContainer(
                        backgroundColor: CustomColor.appColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Text(
                          'Buy Now',
                          style: textStyle14(context,
                              color: CustomColor.whiteColor),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


