import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';

class PopularServicesWidget extends StatelessWidget {
  const PopularServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Most Popular Services',
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return CustomContainer(
                backgroundColor: Colors.white,
                width: 300,
              );
            },
          ),
        ),
      ],
    );
  }
}
