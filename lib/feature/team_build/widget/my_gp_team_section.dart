import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_container.dart';

class MyGpTeamSection extends StatelessWidget {
  const MyGpTeamSection({super.key});

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
            level: 'Gp',
            address: 'waidhan singrouli mp',
            phone: '8989207770',
            earning: 'My Earning ₹ 00',
          );
        },),
    );
  }
}
