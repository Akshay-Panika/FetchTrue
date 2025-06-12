import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';

class TeamUserWidget extends StatelessWidget {
  const TeamUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
      return CustomContainer(
        height: 150,
      );
    },);
  }
}
