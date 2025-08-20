import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/feature/package/screen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';

class InviteFranchiseSectionWidget extends StatefulWidget {
  const InviteFranchiseSectionWidget({super.key});

  @override
  State<InviteFranchiseSectionWidget> createState() =>
      _InviteFranchiseSectionWidgetState();
}

class _InviteFranchiseSectionWidgetState extends State<InviteFranchiseSectionWidget> {


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          50.height,

          /// Illustration or Banner
          CustomContainer(
            height: dimensions.screenHeight * 0.2,
            width: double.infinity,
            margin: EdgeInsets.zero,
            assetsImg: CustomImage.inviteImage,
          ),
          20.height,

          /// Title & Subtext
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Invite Friends & Businesses',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                'Share your referral code below and\ngrow your team.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
              SizedBox(height: 60),
            ],
          ),

          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {

              if (state is UserInitial) {
                context.read<UserBloc>().add(GetUserById(userSession.userId!));
                return Column(
                  children: [
                    Center(child: shimmerBox(height: 100, width: double.infinity)),
                    50.height,
                    Center(child: shimmerBox(height: 50, width: 200)),
                  ],
                );
              }
              else if(state is UserLoading){
                return Column(
                  children: [
                    Center(child: shimmerBox(height: 100, width: double.infinity)),
                    50.height,
                    Center(child: shimmerBox(height: 50, width: 200)),
                  ],
                );
              }
              else if (state is UserLoaded) {
                final user = state.user;
                final packageActive = user.packageActive == true;
                final referralCode = user.referralCode ?? '';

                if (!packageActive) {
                  return Column(
                    children: [
                      CustomContainer(
                        border: true,
                        height: 100,
                        color: CustomColor.whiteColor,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, color: CustomColor.appColor),
                            10.width,
                            Text(
                              'Upgrade now to start earning',
                              style: textStyle16(context,
                                  color: CustomColor.appColor),
                            ),
                          ],
                        ),
                      ),
                      50.height,
                      CustomContainer(
                        width: 200,
                        color: CustomColor.appColor,
                        child: Center(
                          child: Text(
                            'Upgrade Now',
                            style: textStyle16(context,
                                color: CustomColor.whiteColor),
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PackageScreen(),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return Column(
                    children: [
                      DottedBorder(
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
                                controller: TextEditingController(
                                    text: referralCode),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomContainer(
                                color:
                                CustomColor.appColor.withOpacity(0.8),
                                child: IconButton(
                                  icon: const Icon(Icons.copy,
                                      color: Colors.white),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: referralCode));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text('Copied!')),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      50.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Share this code', style: textStyle16(context)),
                          15.width,
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: IconButton(
                              onPressed: () {
                                final shareMessage =
                                    'Join me on this amazing platform!\nUse my referral code: $referralCode';
                                Share.share(shareMessage);
                              },
                              icon: Icon(Icons.share, color: CustomColor.appColor),
                            ),
                          ),

                        ],
                      ),
                    ],
                  );
                }
              }
              else if (state is UserError) {
                return Center(child: Text("Error: ${state.massage}"));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
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
