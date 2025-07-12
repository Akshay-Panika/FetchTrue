import 'package:fetchtrue/feature/about_us/screen/aboutus_screen.dart';
import 'package:fetchtrue/feature/customer/screen/customer_screen.dart';
import 'package:fetchtrue/feature/more/widget/profile_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/screen/auth_screen.dart';
import '../../cancellation_policy/screen/cancellation_policy_screen.dart';
import '../../coupon/screen/coupon_screen.dart';
import '../../delete_account/screen/delete_account_screen.dart';
import '../../favorite/screen/favorite_screen.dart';
import '../../help_support/screen/help_support_screen.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';
import '../../privacy_policy/screen/pryvacy_policy_screen.dart';
import '../../profile/screen/profile_screen.dart';
import '../../provider/screen/provider_screen.dart';
import '../../refund_policy/screen/refund_policy_screen.dart';
import '../../settings/screen/setting_screen.dart';
import '../../team_build/screen/team_build_screen.dart';
import '../../terms_conditions/screen/term_condition_screen.dart';
import '../../wallet/screen/wallet_screen.dart';
import '../model/user_model.dart';
import '../repository/user_service.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  String? userId;
  String? token;
  UserModel? userData;

  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    final tkn = prefs.getString('token');

    setState(() {
      userId = id;
      token = tkn;
    });

    if (id != null) {
      final user = await userService.fetchUserById(id);
      setState(() {
        userData = user;
      });
    }
  }

  Future<void> signOutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      token = null;
      userId = null;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile', showBackButton: false, showNotificationIcon: true,),

      body:  CustomScrollView(
        slivers: [

          SliverAppBar(
            floating: true,
            toolbarHeight: 200,
            backgroundColor: CustomColor.canvasColor,
            flexibleSpace: FlexibleSpaceBar(
             background: ProfileCardWidget(userData: userData,),
            ),
          ),

          SliverToBoxAdapter(
            child:Column(
              children: [

                // 5.height,
                _buildSection(context,"Account", [
                  _buildTile(context, Icons.person_outline, "Profile", () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),)),),
                  _buildTile(context, Icons.favorite_border, "Favorite", () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userId,),)),),
                  _buildTile(context, Icons.wallet_outlined, "Wallet", () => Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(),)),),
                  _buildTile(context, Icons.card_giftcard, "Package", () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),))),
                  _buildTile(context, Icons.escalator_warning_outlined, "Refer And Earn",() => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),),
                  _buildTile(context, Icons.local_offer_outlined, "Coupon",() => Navigator.push(context, MaterialPageRoute(builder: (context) => CouponScreen(),)),),
                  _buildTile(context, Icons.person_4_outlined, "Provider",() => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderScreen(),)),),
                  _buildTile(context, Icons.person_4, "Customer",() => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerScreen(isMenu: true,),)),),
                ]),

                // 5.height,
                _buildSection(context,"Preferences", [
                  _buildTile(context, Icons.description_outlined, "About Us", () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen(),)),),
                  _buildTile(context, Icons.notifications_active_outlined, "Notifications", () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),)),),
                  _buildTile(context, Icons.settings_outlined, "Settings", () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),)),),
                  _buildTile(context, Icons.support_agent, "Help & Support", () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen(),)),),
                  _buildTile(context, Icons.security, "Privacy & Policy",() => Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),)),),
                  _buildTile(context, Icons.rule, "Terms And Conditions", () => Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditionsScreen(),)),),
                  _buildTile(context, Icons.receipt_long, "Refund Policy", () => Navigator.push(context, MaterialPageRoute(builder: (context) => RefundPolicyScreen(),)),),
                  _buildTile(context, Icons.cancel_outlined, "Cancellation Policy",() => Navigator.push(context, MaterialPageRoute(builder: (context) => CancellationPolicyScreen(),)),),
                ]),

                // 5.height,
                _buildSection(context,"Others", [
                  _buildTile(context, Icons.delete_outline, "Delete Account",() => Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccountScreen(),)),),


                  /// sign in hai to ('Sign Out' ) nhi to (Sign In)
                  _buildTile(
                    context,
                    token != null ? Icons.logout : Icons.login,
                    token != null ? 'Sign Out' : 'Sign In',
                          () async {
                        if (token == null) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AuthScreen()),
                          );

                          /// If login is successful
                          if (result == true) {
                            final prefs = await SharedPreferences.getInstance();
                            setState(() {
                              token = prefs.getString('token');
                              userId = prefs.getString('_id');
                            });
                          }
                        } else {
                          showLogoutDialog(context, () async {
                            await signOutUser();
                            Navigator.pop(context); /// Close dialog
                          });
                        }
                      }
                  ),

                ]),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(left: 15.0,bottom: 5),
          child: Text(title, style:  textStyle14(context,)),
        ),

        CustomContainer(
          border: true,
         backgroundColor: Colors.white,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(top: 0, bottom: 10, right: 10,left: 10),
          child: Column(children: children),
        )
      ],
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      leading: Icon(icon,color: Colors.black54, size: 22),
      title: Text(title, style: textStyle14(context)),
      trailing:  Icon(Icons.arrow_forward_ios, size: 14, color: CustomColor.iconColor,),
      onTap: onTap,
    );
  }
}

void showLogoutDialog(BuildContext context, VoidCallback onConfirmLogout) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: CustomColor.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title:  Text("Log Out", style: textStyle20(context, color: CustomColor.appColor )),
      content: const Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel
          child:  Text("Cancel", style: textStyle14(context, color: Colors.red),),
        ),

        TextButton(
           onPressed: () {
             onConfirmLogout();
           },
          child:  Text("Log Out", style: textStyle14(context, color:CustomColor.appColor),),
        ),

      ],
    ),
  );
}
