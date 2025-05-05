import 'package:flutter/material.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:bizbooster2x/core/widgets/custom_search_bar.dart';
import 'package:bizbooster2x/features/service/screen/service_screen.dart';
import 'package:bizbooster2x/core/widgets/custom_banner.dart';
import 'package:bizbooster2x/core/widgets/custom_height_banner.dart';
import 'package:bizbooster2x/core/widgets/custom_service_list.dart';
import 'package:bizbooster2x/features/home/widget/leads_widget.dart';
import 'package:bizbooster2x/features/search/screen/search_screen.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../widget/profile_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showServicePage = false;
  int _selectedServiceIndex = 0;

  final List<String> _services = [
    'Onboarding',
    'Business',
    'Branding & Marketing',
    'Legal Services',
    'Home Services',
    'IT Services',
    'Education',
    'Finance Services',
    'Franchise',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showServicePage) {
          setState(() {
            _showServicePage = false;
            _selectedServiceIndex = 0;
          });
          return false; // don't exit the screen
        }
        return true; // allow exit if service page not shown
      },
      child: Scaffold(
        appBar: CustomAppBar(
            leading: _showServicePage ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showServicePage = false;
                    _selectedServiceIndex = 0;
                  });
                },
                child:  Icon(Icons.dashboard, size: 25,),),
            ) : null,
          leadingWidth: !_showServicePage ?0:52,
         titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(_showServicePage ? _services[_selectedServiceIndex]:"BizBooster2x", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
                SizedBox(height: 2),
                Text(
                  "Waidhan Singrauli Madhya Pradesh Pin- 486886",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          showCartIcon: true,
          showNotificationIcon: true,
        ),

        body: _showServicePage
            ? ServiceScreen(serviceName: _services[_selectedServiceIndex])
            : CustomScrollView(
          slivers: [

            /// Profile card
            SliverToBoxAdapter(child: ProfileCardWidget(),),

            /// Search bar
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              flexibleSpace: CustomSearchBar(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                ),
              ),
            ),

            /// Data
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBanner(),
                    const SizedBox(height: 10),

                    /// Leads
                    LeadsWidget(),
                    const SizedBox(height: 20),

                    /// Services
                    CustomHeadline(headline: 'Services'),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _services.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.11 / 1,
                      ),
                      itemBuilder: (context, index) {
                        return CustomContainer(
                          onTap: () {
                            setState(() {
                              _selectedServiceIndex = index;
                              _showServicePage = true;
                            });
                          },
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(child: CustomContainer(margin: EdgeInsets.zero)),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  _services[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    CustomServiceList(),
                    const SizedBox(height: 20),

                    CustomHeightBanner(),
                    const SizedBox(height: 20),

                    CustomServiceList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
