import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';

class MyNonGpTeamSection extends StatelessWidget {
  const MyNonGpTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(itemBuilder: (context, index) {
        return CustomContainer(
          height: 150,
        );
      },),
    );
  }
}
