import 'package:flutter/cupertino.dart';
import '../../../core/widgets/custom_container.dart';

class MyGpTeamSection extends StatelessWidget {
  const MyGpTeamSection({super.key});

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
