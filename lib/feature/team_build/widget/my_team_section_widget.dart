import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/feature/team_build/widget/team_gp_widget.dart';
import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/team_build/widget/relationship_manager_card_widget.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_toggle_taps.dart';
import '../../../helper/Contact_helper.dart';
import '../../more/model/user_model.dart';
import '../../my_admin/model/referral_user_model.dart';
import '../../my_admin/repository/referral_service.dart';
import '../model/non_gp_model.dart';
import '../repository/non_gp_service.dart';
import '../repository/relationship_manager_service.dart';
import '../repository/referral_service_conferm.dart';
import '../model/relationship_manager_model.dart';
import 'non_gp_widget.dart';

class MyTeamSectionWidget extends StatefulWidget {
  final UserModel? userData;

  const MyTeamSectionWidget({super.key, this.userData});

  @override
  State<MyTeamSectionWidget> createState() => _MyTeamSectionWidgetState();
}

class _MyTeamSectionWidgetState extends State<MyTeamSectionWidget> {
  final _referralController = TextEditingController();
  final _referralService = ReferralService();
  final _confirmService = ReferralServiceConfirm();

  ReferralUserModel? _referralUser;
  RelationshipManagerModel? relationshipManager;

  bool isLoading = true;
  bool _verifyReferralCode = false;
  bool _isCodeEmpty = true;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    fetchRelationshipManager();
    fetchMyLeads();
  }

  Future<void> fetchRelationshipManager() async {
    if (widget.userData?.referredBy == null) {
      setState(() => isLoading = false);
      return;
    }

    final result = await RelationshipManagerService()
        .fetchUserById(widget.userData!.referredBy.toString());

    setState(() {
      relationshipManager = result;
      isLoading = false;
    });
  }

  int _tapIndex = 0;

  List<NonGpModel> _nonGpList = [];
  List<NonGpModel> _teamGpList = [];
  bool isTeamLoading = true;

  Future<void> fetchMyLeads() async {
    setState(() => isTeamLoading = true); // 🔄 Start loading

    final result = await NonGpService().fetchMyLeads(widget.userData!.id);

    setState(() {
      _nonGpList = result.where((e) => e.packageActive == false).toList(); // Non-GP
      _teamGpList = result.where((e) => e.packageActive == true).toList(); // Team-GP
      isTeamLoading = false; // ✅ Done loading
    });
  }


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: isLoading
              ? LinearProgressIndicator(color: CustomColor.appColor, minHeight: 3)
              : relationshipManager != null
              ? RelationshipManagerCardWidget(referralUser: relationshipManager!)
              : _referralUser == null
              ? _buildReferralInput(context)
              : _buildReferralPreview(context),
        ),


        /// Tabs
        SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal:dimensions.screenHeight*0.02,vertical: 10),
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
        SliverToBoxAdapter(
          child: isTeamLoading
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator(color: CustomColor.appColor)),
          )
              : (_tapIndex == 0 && _nonGpList.isEmpty) || (_tapIndex == 1 && _teamGpList.isEmpty)
              ? _buildEmptyIconMessage(context)
              : null,
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final list = _tapIndex == 0 ? _nonGpList : _teamGpList;
              return _tapIndex == 0
                  ? NonGpWidget(data: list[index])
                  : TeamGpWidget(data: list[index]);
            },
            childCount: _tapIndex == 0 ? _nonGpList.length : _teamGpList.length,
          ),
        ),


        SliverToBoxAdapter(child:SizedBox(height: dimensions.screenHeight*0.02,)),

      ],
    );
  }

  Widget _buildReferralInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        color: CustomColor.appColor,
        dashPattern: [10, 5],
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        borderPadding: const EdgeInsets.all(10),
        child: Row(
          children: [
            30.width,
            Expanded(
              child: TextField(
                controller: _referralController,
                style: textStyle14(context, color: CustomColor.descriptionColor),
                decoration: InputDecoration(
                  hintText: "You haven't been referred yet.",
                  hintStyle: textStyle14(context, color: CustomColor.descriptionColor),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() => _isCodeEmpty = value.trim().isEmpty);
                },
              ),
            ),
            CustomContainer(
              backgroundColor: CustomColor.appColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              onTap: _isCodeEmpty
                  ? () => showCustomSnackBar(context, 'Please enter referral code')
                  : () async {
                final referralCode = _referralController.text.trim();
                setState(() => _verifyReferralCode = true);
                final user = await _referralService.getUserByReferralCode(referralCode);
                setState(() => _verifyReferralCode = false);
                if (user != null) {
                  setState(() => _referralUser = user);
                } else {
                  showCustomSnackBar(context, 'Invalid Referral Code');
                }
              },
              child: _verifyReferralCode
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : Text(
                'Verify',
                style: TextStyle(
                  color: CustomColor.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReferralPreview(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          border: true,
          borderColor: CustomColor.appColor,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          backgroundColor: CustomColor.whiteColor,
          child: Column(
            children: [
              5.height,
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                        backgroundImage: AssetImage(CustomImage.nullImage),
                      ),

                      Positioned(
                          bottom: 0,right: 0,
                          child: Icon(Icons.check_circle, color: Colors.grey,)),
                    ],
                  ),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Relationship Manager', style: textStyle14(context, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 5),
                      Text("Name: ${_referralUser!.fullName}"),
                      Text("Email: ${_referralUser!.email}"),
                      Text("Mobile: ${_referralUser!.mobileNumber}"),
                    ],
                  ),
                ],
              ),
              10.height,

              CustomContainer(
                border: true,
                backgroundColor: CustomColor.whiteColor,
                borderColor: CustomColor.appColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Teams : 00', style: textStyle14(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              ContactHelper.call(_referralUser!.mobileNumber);
                            },
                            child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),
                        50.width,
                        InkWell(
                            onTap: () {
                              ContactHelper.whatsapp(_referralUser!.mobileNumber, 'hello ${_referralUser!.fullName}');
                            },
                            child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildButton(
              context,
              label: 'Cancel',
              textColor: Colors.red,
              onTap: () => setState(() => _referralUser = null),
            ),
            _buildButton(
              context,
              label: _isConfirming ? 'Loading...':'Confirm',
              textColor: Colors.green,
              onTap: _isConfirming
                  ? null
                  : () async {
                final userId = widget.userData?.id;
                final referralCode = _referralController.text.trim();

                if (userId == null || userId.isEmpty || referralCode.isEmpty) {
                  showCustomSnackBar(context, "User ID or Referral Code is missing.");
                  return;
                }

                setState(() {_isConfirming = true;});
                final success = await _confirmService.setReferralForUser(
                  userId: userId,
                  referralCode: referralCode,
                );

                if (success) {
                  showCustomSnackBar(context, "Referral confirmed!");

                  /// ✅ First, clear preview and show loading
                  setState(() {
                    _referralUser = null;
                    isLoading = true;
                  });

                  /// ✅ Fetch updated Relationship Manager data
                  await fetchRelationshipManager();
                } else {
                  showCustomSnackBar(context, "Referral failed or already referred.");
                }
                setState(() {_isConfirming = false;});
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildButton(BuildContext context, {required String label, required Color textColor, VoidCallback? onTap}) {
    return CustomContainer(
      width: 150,
      border: true,
      borderColor: CustomColor.appColor,
      backgroundColor: Colors.transparent,
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          style: textStyle16(context, color: textColor),
        ),
      ),
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


Widget _buildEmptyIconMessage(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 50),
    child: Column(
      children: [
        60.height,
        Icon(Icons.group_off, size: 80, color: Colors.grey.shade400),
        const SizedBox(height: 10),
        Text(
          'No team members found',
          style: textStyle14(context, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}
