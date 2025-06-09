import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';

class ProviderGalleryWidget extends StatelessWidget {
  const ProviderGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemBuilder: (context, index) {
        return CustomContainer(border: true,
          backgroundColor: Colors.white,
        );
      },);
  }
}
