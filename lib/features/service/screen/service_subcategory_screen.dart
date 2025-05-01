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

      body: Column(
        children: [

          /// Filter
          CustomContainer(height: 40,),


          Expanded(
            child: Row(
              children: [

                /// Service type
                Expanded(child: CustomContainer(
                  child: ListView.builder(
                    itemCount: 12,
                    itemBuilder: (context, index) {
                    return CustomContainer(height: 85,margin: EdgeInsets.all(5),);
                  },),
                )),

                /// Services
                Expanded(
                    flex: 2,
                    child: CustomContainer(
                  child: ListView.builder(
                    itemCount: 12,
                    itemBuilder: (context, index) {
                    return CustomContainer(height: 150,margin: EdgeInsets.all(5),);
                  },),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
