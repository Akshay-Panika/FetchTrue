import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/package/screen/package_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';


class ProfileCardWidget extends StatelessWidget {
  final  String currentUser;
  final  String email;
  final  String date;
  const ProfileCardWidget({super.key, required this.currentUser, required this.date, required this.email});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      // boxShadow: true,
      backgroundColor: CustomColor.whiteColor,
      padding: const EdgeInsets.all(15),
      child:
      currentUser == null
          ?  _buildShimmerEffect()
          :
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// TOP ROW: Avatar + Name + Email
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   CircleAvatar(
                     radius: 30,
                     backgroundColor: CustomColor.whiteColor,
                     backgroundImage: AssetImage('assets/image/Null_Profile.jpg'),
                   ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser ?? 'User name',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email ?? 'Email',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),

              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PackageScreen())),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColor.appColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.leaderboard_outlined, size: 16),
                      SizedBox(width: 5),
                      Text('GP', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Divider(),

          /// BOTTOM STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatus(value: date, valueType: 'Joining date'),
              _buildStatus(value: '00', valueType: 'Lead Completed'),
              _buildStatus(value: '00', valueType: 'Total Earning'),
            ],
          )
        ],
      ),
    );
  }

  /// STATUS BOX UI
  Widget _buildStatus({required String value, required String valueType}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          valueType,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: CustomColor.descriptionColor),
        ),
      ],
    );
  }
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(radius: 30, backgroundColor: Colors.grey.shade300),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey),),
                const SizedBox(height: 8),
                Container(height: 10, width: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey),),
              ],
            )
          ],
        ),
        Divider(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (_) {
            return Column(
              children: [
                Container(height: 12, width: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey),),
                const SizedBox(height: 5),
                Container(height: 10, width: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey),),
              ],
            );
          }),
        )
      ],
    ),
  );
}