import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/team_build/model/my_team_model.dart';
import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';

class MyNonGpTeamSection extends StatelessWidget {
  final List<MyTeamModel> members;
  const MyNonGpTeamSection({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return SafeArea(
      child: ListView.builder(
        itemCount: members.length,
        padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.01),
        itemBuilder: (context, index) {

          final member = members[index].user;
          final earnings = members[index].totalEarningsFromShare2;

        return TeamCardWidget(
          radius: 25,
          backgroundImage: member!.profilePhoto != null && member.profilePhoto!.isNotEmpty
              ? NetworkImage(member.profilePhoto!)
              :  AssetImage(CustomImage.nullImage) as ImageProvider,
          id: member.id,
          memberId: member.userId,
          name: member.fullName,
          level: member.packageStatus== 'nonGP'?'Non-GP':member.packageStatus,
          address: _getMemberAddress(member),
          phone: member.mobileNumber,
          earning: earnings.toString(),
          status: member.isDeleted,
        );
      },),
    );
  }

  String _getMemberAddress(User member) {
    Address? address;

    if (member.homeAddress != null &&
        _isAddressValid(member.homeAddress!)) {
      address = member.homeAddress;
    } else if (member.workAddress != null &&
        _isAddressValid(member.workAddress!)) {
      address = member.workAddress;
    } else if (member.otherAddress != null &&
        _isAddressValid(member.otherAddress!)) {
      address = member.otherAddress;
    }

    if (address != null) {
      List<String> parts = [
        address.houseNumber,
        address.landmark,
        address.city,
        address.state,
        address.pinCode,
        address.country
      ];
      return parts.where((part) => part.isNotEmpty).join(", ");
    }

    return "";
  }

  bool _isAddressValid(Address address) {
    return address.houseNumber.isNotEmpty ||
        address.landmark.isNotEmpty ||
        address.city.isNotEmpty ||
        address.state.isNotEmpty ||
        address.pinCode.isNotEmpty ||
        address.country.isNotEmpty;
  }
}
