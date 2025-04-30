import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/banner_widget.dart';
import '../widget/just_for_you_widget.dart';
import '../widget/leads_widget.dart';
import '../widget/popular_services_widget.dart';
import '../widget/recommended_services_widget.dart';
import '../widget/services_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _showServicePage = false;
  int _selectedServiceIndex = 0;


  List _services = ['Onboarding', 'Business', 'Branding & Marketing', 'Legal Services', 'Home Services', 'IT Services', 'Education', 'Finance Services', 'Franchise'];


  @override
  Widget build(BuildContext context) {
    print('___________________________________ Build Home screen');
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Theme.of(context).cardColor,
         surfaceTintColor: Theme.of(context).cardColor,
         elevation: 0,
         leading: !_showServicePage ? SizedBox(): Padding(
           padding: EdgeInsets.only(left: 16.0),
           child: InkWell(
               onTap: () {
                 setState(() {
                   _showServicePage = false;
                 });
               },
               child: Icon(Icons.dashboard, color: Colors.black54, size: 40,)),
         ),
         leadingWidth: !_showServicePage ?0:52,
         title: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: const [
             Text("BizBooster2x", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w600,),),
             SizedBox(height: 2),
             Text("Waidhan Singrauli Madhya Pradesh Pin- 486886", style: TextStyle(fontSize: 12, color: Colors.grey, overflow: TextOverflow.ellipsis,),),
           ],
         ),
         actions:  [
           IconButton(onPressed: (){}, icon: Icon(Icons.notifications_active_outlined, color: Colors.black87),),
           IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined, color: Colors.black87),),
         ],
       ),
       body: _showServicePage ? Center(child: Text('${_services[_selectedServiceIndex]}'),):
       CustomScrollView(
         slivers: [

           SliverAppBar(
             toolbarHeight: 60,
             floating: true,
             backgroundColor: Theme.of(context).cardColor,
             surfaceTintColor: Theme.of(context).cardColor,
             elevation: 0,
             flexibleSpace:  CustomContainer(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Search here..."),
                   Icon(CupertinoIcons.search, color: Colors.black54,)
                 ],
               ),
             ),
           ),

           SliverToBoxAdapter(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [

                 /// banner
                 BannerWidget(),
                 SizedBox(height: 10,),

                 /// Leads
                 LeadsWidget(),
                 SizedBox(height: 20,),

                 /// Services
                 //ServicesWidget(),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 15.0),
                       child: Text('Services', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                     ),
                     GridView.builder(
                       shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                       scrollDirection: Axis.vertical,
                       itemCount: _services.length,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 3,
                         childAspectRatio: 1.11 / 1,
                         // mainAxisExtent: 100,
                       ),
                       itemBuilder: (context, index) {
                         return CustomContainer(
                           onTap: () {
                             setState(() {
                               _selectedServiceIndex = index;
                               _showServicePage = true;
                             });
                           },
                           padding: EdgeInsets.all(0),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Expanded(
                                 child: CustomContainer(
                                   margin: EdgeInsets.all(0),
                                 ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.all(5.0),
                                 child: Text(_services[index].toString(), style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                               ),
                             ],
                           ),
                         );
                       },
                     ),
                   ],
                 ),
                 SizedBox(height: 20,),

                 /// Popular Services
                 PopularServicesWidget(),
                 SizedBox(height: 20,),

                 /// Popular Services
                 RecommendedServicesWidget(),
                 SizedBox(height: 20,),

                 /// Just for you
                 JustForYouWidget(),
                 SizedBox(height: 20,),

                 /// Popular Services
                 PopularServicesWidget(),
                 SizedBox(height: 20,),
               ],
             ),
           )
         ],
       ),
     );
  }
}
