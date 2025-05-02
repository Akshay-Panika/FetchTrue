import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/features/search/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../service/screen/service_screen.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../core/widgets/custom_height_banner.dart';
import '../widget/leads_widget.dart';
import '../../../core/widgets/custom_service_list.dart';

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
         elevation: 0,
         leading: !_showServicePage ? SizedBox(): Padding(
           padding: EdgeInsets.only(left: 16.0),
           child: InkWell(
               onTap: () {
                 setState(() {
                   _showServicePage = false;
                 });
               },
               child: Icon(Icons.dashboard, color: Colors.black87, size: 40,)),
         ),
         leadingWidth: !_showServicePage ?0:52,
         title: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: const [
             Text("BizBooster2x", style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w600,),),
             SizedBox(height: 2),
             Text("Waidhan Singrauli Madhya Pradesh Pin- 486886", style: TextStyle(fontSize: 12, color: Colors.grey, overflow: TextOverflow.ellipsis,),),
           ],
         ),
         actions:  [
           IconButton(onPressed: (){}, icon: Icon(Icons.notifications_active_outlined, ),),
           IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined),),
         ],
       ),
       body: _showServicePage ? ServiceScreen(serviceName: _services[_selectedServiceIndex],):
       CustomScrollView(
         slivers: [

           SliverAppBar(
             toolbarHeight: 60,
             floating: true,
             flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
           ),

           SliverToBoxAdapter(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [

                 /// banner
                 CustomBanner(),
                 SizedBox(height: 10,),

                 /// Leads
                 LeadsWidget(),
                 SizedBox(height: 20,),

                 /// Services
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     CustomHeadline(headline: 'Services',),

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
                 CustomServiceList(),
                 SizedBox(height: 20,),

                 /// Just for you
                 CustomHeightBanner(),
                 SizedBox(height: 20,),

                 /// Popular Services
                 CustomServiceList(),
                 SizedBox(height: 20,),
               ],
             ),
           )
         ],
       ),
     );
  }
}



