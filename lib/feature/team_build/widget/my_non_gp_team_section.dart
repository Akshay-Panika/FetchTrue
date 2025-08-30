import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';

class MyNonGpTeamSection extends StatelessWidget {
  const MyNonGpTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
        return TeamCardWidget(
          radius: 25,
          backgroundImage: AssetImage(CustomImage.nullImage),
          name: 'Akshay',
          id: '#00000',
          level: 'Non-GP',
          address: 'waidhan singrouli mp',
          phone: '8989207770',
          earning: 'Earning\n Opportunity ₹ 00',
        );
      },),
    );
  }
}
