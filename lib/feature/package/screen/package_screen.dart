import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  String selectedPlan = 'gp';

  final Map<String, Map<String, dynamic>> packages = {
    'gp': {
      'packageName': 'Growth Partner (GP)',
      'price': '₹30,000 - ₹50,000/Month',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Team Building Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Marketing Support',
          'dec':'Earn 5% to 15% revenue share.',
        },
      ]
    },
    'sgp': {
      'packageName': 'Super Growth Partner (SGP)',
      'price': '₹50,000 - ₹70,000/Month',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'dec':'Earn up to 15% revenue share on all successful leads you generate.',
        },
        {
          'headline':'Team Building Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Team Revenue Income',
          'dec':'empty'
        },
        {
          'headline':'Marketing Support',
          'dec':'Earn 5% to 15% revenue share.',
        },
      ]
    },
    'pgp': {
      'packageName': 'Premium Growth Partner (SGP)',
      'price': '₹70,000 - ₹1,00,000/Month ',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'dec':'Earn up to 15% revenue share on all successful leads you generate.',
        },
        {
          'headline':'Team Building Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Team Revenue Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Marketing Support',
          'dec':'Earn 5% to 15% revenue share.',
        },
      ]
    },
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(title: 'Package',showBackButton: true,),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: 15.height,),
          SliverAppBar(
          pinned: false,
          floating: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 40,
          flexibleSpace: _buildEnhancedToggleSwitch(),
        ),
        SliverToBoxAdapter(child: 15.height,),


            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildEnhancedMainCard(packages[selectedPlan]!),
                  15.height,

                  if(selectedPlan == 'gp')
                  _buildPaymentCard(context),
                ],
              ),
            ),

            SliverToBoxAdapter(child: 150.height,)
          ],
        ),
      ),
    );
  }

  /// 🔹 Custom Toggle with 3 Tabs
  Widget _buildEnhancedToggleSwitch() {
    final tabs = ['gp', 'sgp', 'pgp'];

    return CustomContainer(
      borderColor: CustomColor.appColor,
      color: CustomColor.whiteColor,
      margin: EdgeInsets.symmetric(horizontal: 50),
      padding: EdgeInsets.zero,
      child: Row(
        children: tabs.map((tab) {
          bool isSelected = selectedPlan == tab;
          String label = tab.toUpperCase();
          return Expanded(
            child: CustomContainer(
              color: isSelected ? CustomColor.appColor : Colors.transparent,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Center(
                child: Text(label,
                  style: textStyle14(context, color: isSelected ? Colors.white : Colors.grey[600],),),
              ),
              onTap: () {setState(() {selectedPlan = tab;});},
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Main Card with Pricing
  Widget _buildEnhancedMainCard(Map<String, dynamic> package) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomContainer(
          color: CustomColor.whiteColor,
          padding: const EdgeInsets.all(20),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 32,
                backgroundColor: CustomColor.appColor,
                child: CircleAvatar(radius: 31,backgroundColor: CustomColor.whiteColor,),
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${package['packageName']}',style: textStyle16(context, color: CustomColor.appColor),),
                  10.height,
                  Text('${package['price']}', style: textStyle12(context, color: CustomColor.greenColor),),
                  Text('${package['monthFixEarning']}', style: textStyle14(context, color: CustomColor.greenColor),),
                ],
              )
            ],
          ),
        ),
        10.height,


        _buildEnhancedFeaturesSection(context),
       10.height,

       Container(
         padding: const EdgeInsets.all(10),
         margin: const EdgeInsets.symmetric(horizontal: 10),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10),
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               CustomColor.whiteColor,
               Colors.grey.shade200,
             ],
           ),
         ),
         child: Column(
           spacing: 20,
           children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('How to promoted GP to SGP?', style: textStyle18(context),),
                 Text('Recruit 10 Growth Partner to become a Super Growth Partner (SGP)', style: textStyle14(context,color: CustomColor.descriptionColor),),
               ],
             ),
             250.height,
           ],
         ),
       ),
      ],
    );
  }
}

/// What’s Includes
Widget _buildEnhancedFeaturesSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  CustomColor.appColor,
                ],
              ),
            ),
          ),
        ),
        16.width,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(Icons.star, color: CustomColor.appColor, size: 16),
            6.width,
            Text('What’s Includes', style: textStyle14(context, color: CustomColor.appColor),),
          ],
        ),
        16.width,
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColor.appColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget _buildPaymentCard(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Unlock premium features and grow your team',style: textStyle14(context,color: CustomColor.descriptionColor),),
        15.height,

        CustomContainer(
          color: CustomColor.whiteColor,
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Growth Total'),
                  CustomAmountText(amount: '199999')
                ],
              ),
              Divider(),

              CustomContainer(
               width: double.infinity,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                   Row(
                     children: [
                       Expanded(child: Container()),
                       Expanded(flex: 2,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 Text('We Assure You up to', style: textStyle14(context),),
                                 Text(' 5X Return', style: textStyle14(context, color: CustomColor.appColor),),
                               ],
                             ),
                             5.height,

                             Text('If you earn less than 5 Lakh in 3 year, we ‘ll refund up to 5X your initial amount', textAlign: TextAlign.right,)
                           ],
                         ),
                       ),
                     ],
                   ),
                   Text('Safe, secure, and assured returns on your investment.')
                  ],
                ),
              ),
              10.height,
              
              CustomContainer(
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                color: CustomColor.appColor,
                child: Text('Activate Now', style: textStyle16(context, color: CustomColor.whiteColor),),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
