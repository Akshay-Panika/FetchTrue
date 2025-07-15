import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/user_model.dart';
import '../../package/screen/package_screen.dart';

class ProfileCardWidget extends StatelessWidget {
  final UserModel? userData;
  final bool isLoading;
  const ProfileCardWidget({super.key, required this.userData, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      backgroundColor: CustomColor.whiteColor,
      padding: const EdgeInsets.all(15),
      child: isLoading
          ? _buildShimmerEffect()
          : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/image/Null_Profile.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData?.fullName ?? 'User Name',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userData?.email ?? 'Email',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PackageScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColor.appColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
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
            children: [
              _buildStatus(
                value: userData != null ? _formatDate(userData!.createdAt) : '00/00/25',
                valueType: 'Joining date',
              ),
              _buildStatus(value: '00', valueType: 'Lead Completed'),
              _buildStatus(value: '00', valueType: 'Total Earning'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatus({required String value, required String valueType}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          valueType,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: CustomColor.descriptionColor,
          ),
        ),
      ],
    );
  }

  static String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return "-";
    }
  }

  /// 🔄 Shimmer Loader when userData is null
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 30, backgroundColor: Colors.grey),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (_) {
              return Column(
                children: [
                  Container(
                    height: 12,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 10,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
