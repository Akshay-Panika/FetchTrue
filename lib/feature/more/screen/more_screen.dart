import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/feature/about/screen/about_screen.dart';
import 'package:bizbooster2x/feature/coupon/screen/coupon_screen.dart';
import 'package:bizbooster2x/feature/notification/screen/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../auth/screen/auth_screen.dart';
import '../../cancellation_policy/screen/cancellation_policy_screen.dart';
import '../../delete_account/screen/delete_account_screen.dart';
import '../../favorite/screen/favorite_screen.dart';
import '../../help_support/screen/help_support_screen.dart';
import '../../package/screen/package_screen.dart';
import '../../privacy_policy/screen/pryvacy_policy_screen.dart';
import '../../profile/screen/profile_screen.dart';
import '../../provider/screen/provider_screen.dart';
import '../../refund_policy/screen/refund_policy_screen.dart';
import '../../settings/screen/setting_screen.dart';
import '../../team_lead/screen/team_lead_screen.dart';
import '../../terms_conditions/screen/term_condition_screen.dart';
import '../../wallet/screen/wallet_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  String? token;
  String? user;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedToken = prefs.getString('auth_token');
    final loadedUser = prefs.getString('user');
    print('✅ Token fetched: $loadedToken, User: $loadedUser');

    setState(() {
      token = loadedToken;
      user = loadedUser;
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
            toolbarHeight: 120,
            backgroundColor: CustomColor.canvasColor,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(context, user),
            ),
          ),

          SliverToBoxAdapter(
            child:Column(
              children: [

                // 5.height,
                _buildSection(context,"Account", [
                  _buildTile(context, Icons.person_outline, "Profile", () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),)),),
                  _buildTile(context, Icons.favorite_border, "Favorite", () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),)),),
                  _buildTile(context, Icons.wallet_outlined, "Wallet", () => Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(),)),),
                  _buildTile(context, Icons.card_giftcard, "Package", () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),))),
                  _buildTile(context, Icons.escalator_warning_outlined, "Refer And Earn",() => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),),
                  _buildTile(context, Icons.local_offer_outlined, "Coupon",() => Navigator.push(context, MaterialPageRoute(builder: (context) => CouponScreen(),)),),
                  _buildTile(context, Icons.person_4_outlined, "Provider",() => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderScreen(),)),),
                ]),

                // 5.height,
                _buildSection(context,"Preferences", [
                  _buildTile(context, Icons.description_outlined, "About Us", () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen(),)),),
                  _buildTile(context, Icons.notifications_active_outlined, "Notifications", () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),)),),
                  _buildTile(context, Icons.settings_outlined, "Settings", () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),)),),
                  _buildTile(context, Icons.support_agent, "Help & Support", () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen(),)),),
                  _buildTile(context, Icons.security, "Privacy & Policy",() => Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),)),),
                  _buildTile(context, Icons.rule, "Terms And Conditions", () => Navigator.push(context, MaterialPageRoute(builder: (context) => TermConditionScreen(),)),),
                  _buildTile(context, Icons.receipt_long, "Refund Policy", () => Navigator.push(context, MaterialPageRoute(builder: (context) => RefundPolicyScreen(),)),),
                  _buildTile(context, Icons.cancel_outlined, "Cancellation Policy",() => Navigator.push(context, MaterialPageRoute(builder: (context) => CancellationPolicyScreen(),)),),
                ]),

                // 5.height,
                _buildSection(context,"Others", [
                  _buildTile(context, Icons.delete_outline, "Delete Account",() => Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccountScreen(),)),),

                  _buildTile(
                    context,
                    Icons.logout,
                    token != null ? 'Sign Out' : 'Sign In',
                        () async {
                      if (token == null) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AuthScreen()));
                      } else {
                        showLogoutDialog(context, () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          setState(() {
                            token = null;
                            user = null;
                          });
                          Navigator.pop(context);
                        });
                      }
                    },
                  ),

                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String? user) {
    return CustomContainer(
      border: true,
     backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
      child: Row(
        children: [
           CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).cardColor,
             backgroundImage: AssetImage(CustomImage.nullImage),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(user != null && user.isNotEmpty ? user : "User Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("xyz@bizbooster.com", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),

          CustomContainer(
            border: true,
            backgroundColor: CustomColor.appColor.withOpacity(0.1),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
            children: [
              Icon(Icons.leaderboard_outlined, size: 16, color: CustomColor.appColor,),
              10.width,
              Text('GP', style: textStyle14(context),)
            ],
          ))

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
