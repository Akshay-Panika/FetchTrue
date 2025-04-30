import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';

class LeadsWidget extends StatelessWidget {
  const LeadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text('Leads', style: TextStyle(fontSize: 16),),
        ),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: CustomContainer(),),
              Expanded(
                child: Column(
                  children: [
                   Expanded(child:  CustomContainer(),),
                   Expanded(child:  CustomContainer(),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
