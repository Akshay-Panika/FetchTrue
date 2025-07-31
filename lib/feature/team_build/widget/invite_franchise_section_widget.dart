import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/feature/package/screen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/model/user_model.dart';

class InviteFranchiseSectionWidget extends StatefulWidget {
  final UserModel? userData;
  const InviteFranchiseSectionWidget({super.key, this.userData});

  @override
  State<InviteFranchiseSectionWidget> createState() => _InviteFranchiseSectionWidgetState();
}

class _InviteFranchiseSectionWidgetState extends State<InviteFranchiseSectionWidget> {
  Dimensions? dimensions;

  @override
  Widget build(BuildContext context) {
    dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        50.height,

        /// Illustration or Banner
        CustomContainer(
          height: dimensions!.screenHeight * 0.2,
          width: double.infinity,
          margin: EdgeInsets.zero,
          assetsImg: CustomImage.inviteImage,
        ),
        20.height,

        /// Title & Subtext
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Invite Friends & Businesses',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Share your referral code below and\ngrow your team.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            const SizedBox(height: 60),
          ],
        ),

        /// ✅ Referral Code Box or Lock message with shimmer
        widget.userData == null
            ? shimmerBox(height: 100, width: double.infinity)
            : widget.userData!.packageActive == true
            ? DottedBorder(
          color: Colors.grey,
          dashPattern: [10, 5],
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          borderPadding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(width: 25),
              Expanded(
                flex: 2,
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText:
                    widget.userData?.referralCode ?? 'YourCode',
                    hintStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CustomContainer(
                  backgroundColor:
                  CustomColor.appColor.withOpacity(0.8),
                  child: IconButton(
                    icon: const Icon(Icons.copy,
                        color: Colors.white),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                            text: widget.userData?.referralCode ??
                                ''),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied!')),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
            : CustomContainer(
          border: true,
          height: 100,
          backgroundColor: CustomColor.whiteColor,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock,
                  color: CustomColor.appColor),
              10.width,
              Text(
                'Upgrade now to start earning',
                style: textStyle16(context,
                    color: CustomColor.appColor),
              ),
            ],
          ),
        ),
        60.height,

        /// ✅ Share / Upgrade Button with shimmer
        widget.userData == null
            ? shimmerBox(height: 50, width: 200)
            : widget.userData!.packageActive == true
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Share this code'),
                15.width,
                CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: IconButton(
                onPressed: () {},
                icon:  Icon(Icons.share,
                    color: CustomColor.appColor),
                          ),
                        ),
              ],
            )
            : CustomContainer(
          width: 200,
          backgroundColor: CustomColor.appColor,
          child: Center(
            child: Text(
              'Upgrade Now',
              style: textStyle16(context,
                  color: CustomColor.whiteColor),
            ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(userId: userSession.userId!,),)),
        ),

        SizedBox(height: dimensions!.screenHeight * 0.05),
      ],
    );
  }

  /// ✅ Reusable shimmer widget
  Widget shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}