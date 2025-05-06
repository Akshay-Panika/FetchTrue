import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/features/service/screen/service_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceSubcategoryScreen extends StatelessWidget {
  final String headline;
  const ServiceSubcategoryScreen({super.key, required this.headline});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '$headline',showBackButton: true,showSearchIcon: true,),

      body: SafeArea(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
        
            /// Filter
            CustomContainer(height: 40,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(0),
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
              return CustomContainer(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                width: 100,child: Center(child: Text("Headline")),);
            },),
            ),

            /// Service type
            Expanded(
              child: CustomContainer(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [

                    Expanded(child: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return CustomContainer(
                          height: 100,
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
                                child: Text('Headline', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        );
                    },)),
                        
                    /// Services
                    Expanded(
                        flex: 2,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return CustomContainer(
                              height: 180,
                              padding: EdgeInsets.all(0),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: '',),)),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Service Name', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Start from: ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                Text('10.00', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                Icon(Icons.currency_rupee, size: 12,)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Start from: ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                Text('10.00', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                Icon(Icons.currency_rupee, size: 12,)
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
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
