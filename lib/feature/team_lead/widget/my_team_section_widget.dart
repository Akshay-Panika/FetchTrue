import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/team_lead/widget/team_gp_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_toggle_taps.dart';
import '../../my_admin/model/referral_user_model.dart';
import '../../my_admin/repository/referral_service.dart';
import 'my_leader_card_widget.dart';
import 'non_gp_widget.dart';

class MyTeamSectionWidget extends StatefulWidget {
  const MyTeamSectionWidget({super.key});

  @override
  State<MyTeamSectionWidget> createState() => _MyTeamSectionWidgetState();
}

class _MyTeamSectionWidgetState extends State<MyTeamSectionWidget> {
  bool _verifyReferralCode = false;
  bool _confirm = false;
  bool _isLoading = false;
  bool _isCodeEmpty = true;

  ReferralUserModel? _referralUser;

  final _controller = TextEditingController();
  final _referralService = ReferralService();

  int _tapIndex = 0;
  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight * 0.010)),

        /// Referral Input
        SliverToBoxAdapter(
          child: !_confirm
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
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        _isCodeEmpty = value.trim().isEmpty;
                      });
                    },
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      hintText: 'Referral Code...',
                      hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GestureDetector(
                    onTap: _isCodeEmpty
                        ? () {

                      showCustomSnackBar(context, 'Please enter referral code');
                    }
                        : () async {
                      final code = _controller.text.trim();
                      setState(() => _isLoading = true);
                      final user = await _referralService.getUserByReferralCode(code);
                      setState(() => _isLoading = false);

                      if (user != null) {
                        setState(() {
                          _referralUser = user;
                          _verifyReferralCode = true;
                        });
                      } else {
                        showCustomSnackBar(context, 'Invalid Referral Code');
                      }
                    },
                    child: CustomContainer(
                      backgroundColor: _isCodeEmpty
                          ? Colors.grey.shade400
                          : CustomColor.appColor.withOpacity(0.8),
                      child: const Center(
                        child: Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              : const SizedBox.shrink(),
        ),
        SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight * 0.010)),

        /// Referral User Card
        if (_verifyReferralCode && _referralUser != null)
          SliverToBoxAdapter(
            child: Column(
              children: [
                MyLeaderCardWidget(referralUser: _referralUser!),
                if (!_confirm)
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.02),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomContainer(
                            border: true,
                            backgroundColor: CustomColor.whiteColor,
                            onTap: () {
                              setState(() {
                                _controller.clear();
                                _referralUser = null;
                                _verifyReferralCode = false;
                                _isCodeEmpty = true;
                              });
                            },
                            child: Center(
                              child: Text('Cancel', style: textStyle16(context, color: CustomColor.redColor)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomContainer(
                            border: true,
                            backgroundColor: CustomColor.whiteColor,
                            onTap: () {
                              setState(() {
                                _confirm = true;
                              });
                            },
                            child: Center(
                              child: Text('Confirm', style: textStyle16(context, color: CustomColor.appColor)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),


        /// Tabs
        SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal:dimensions.screenHeight*0.02,vertical: 8),
                child: CustomToggleTabs(
                  labels: ['Non-GP', 'Team-GP'],
                  selectedIndex: _tapIndex,
                  onTap: (index) {
                    setState(() {
                      _tapIndex = index;
                    });
                  },
                ),
              ),
            )),

        /// Non- gp, Team gp
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return _tapIndex == 0
                  ? const NonGpWidget()
                  : const TeamGpWidget();
            },
            childCount: _tapIndex == 0 ? 6 : 5,
          ),
        ),
        SliverToBoxAdapter(child:SizedBox(height: dimensions.screenHeight*0.02,)),


      ],
    );
  }
}


/// _StickyHeaderDelegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 50,
      child: Material( // Optional: for background color
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}