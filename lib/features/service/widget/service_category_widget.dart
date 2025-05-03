import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';
import '../screen/service_subcategory_screen.dart';

class ServiceCategoryWidget extends StatelessWidget {
   ServiceCategoryWidget({super.key});


   final List<String> _services = [
     'App Download',
     'Customer Onboarding',
     'Employee Onboarding',
     'Investor Onboarding',
     'Merchant Onboarding',
     'Partner Onboarding',
     'Product Onboarding',
     'Seller Onboarding',
     'Service Onboarding'
   ];
   final List<IconData> _serviceIcons = [
     Icons.download,            // App Download
     Icons.person_add,          // Customer Onboarding
     Icons.group_add,           // Employee Onboarding
     Icons.monetization_on,     // Investor Onboarding
     Icons.store_mall_directory, // Merchant Onboarding
     Icons.people_outline,      // Partner Onboarding
     Icons.production_quantity_limits, // Product Onboarding
     Icons.sell,                // Seller Onboarding
     Icons.build_circle_outlined, // Service Onboarding
   ];

   @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Headline
        CustomHeadline(headline: "Services",),


        /// Services list
        SizedBox(
          height: 100,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            itemBuilder: (context, index) {
              return CustomContainer(
                padding: EdgeInsets.all(0),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceSubcategoryScreen(headline: _services[index],),)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomContainer(
                        backgroundColor: Colors.transparent,
                        margin: EdgeInsets.all(0),
                        child: Icon(_serviceIcons[index], size: 25,color: Colors.grey,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(_services[index], style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
