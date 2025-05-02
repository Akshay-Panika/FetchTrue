import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceSubcategoryScreen extends StatelessWidget {
  const ServiceSubcategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Services',showBackButton: true,),

      body: SafeArea(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
        
            /// Filter
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: Text('Filter', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
            ),
            CustomContainer(height: 40,),
        
            /// Filter
            Padding(
              padding: const EdgeInsets.only(left: 15.0,),
              child: Text('Services', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
            ),
            Expanded(
              child: CustomContainer(
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                        
                    /// Service type
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
