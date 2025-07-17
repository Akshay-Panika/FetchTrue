import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fetchtrue/feature/about_us/screen/aboutus_screen.dart';
import 'package:fetchtrue/feature/customer/screen/customer_screen.dart';
import 'package:fetchtrue/feature/more/widget/profile_card_widget.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/screen/auth_screen.dart';
import '../../auth/user_notifier/user_notifier.dart';
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


class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
        showBackButton: false,
        showNotificationIcon: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            toolbarHeight: 200,
            backgroundColor: CustomColor.canvasColor,
            flexibleSpace: FlexibleSpaceBar(
              background: ProfileCardWidget(),
              // background: Center(
              //   child: Text(
              //     userSession.isLoggedIn
              //         ? "Welcome User ID: ${userSession.userId}"
              //         : "You are not logged in",
              //     style: textStyle16(context, fontWeight: FontWeight.w600),
              //   ),
              // ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSection(context, "Account", [
                  _buildTile(context, Icons.person_outline, "Profile", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  }),
                  _buildTile(context, Icons.favorite_border, "Favorite", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        FavoriteScreen(userId: userSession.userId)));
                  }),
                  _buildTile(context, Icons.wallet_outlined, "Wallet", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                  }),
                  _buildTile(context, Icons.card_giftcard, "Package", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PackageScreen()));
                  }),
                  _buildTile(context, Icons.escalator_warning_outlined, "Refer And Earn", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamLeadScreen()));
                  }),
                  _buildTile(context, Icons.local_offer_outlined, "Coupon", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CouponScreen()));
                  }),
                  _buildTile(context, Icons.person_4_outlined, "Provider", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProviderScreen()));
                  }),
                  _buildTile(context, Icons.person_4, "Customer", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerScreen(isMenu: true)));
                  }),
                ]),
                _buildSection(context, "Preferences", [
                  _buildTile(context, Icons.description_outlined, "About Us", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
                  }),
                  _buildTile(context, Icons.notifications_active_outlined, "Notifications", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                  }),
                  _buildTile(context, Icons.settings_outlined, "Settings", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingScreen()));
                  }),
                  _buildTile(context, Icons.support_agent, "Help & Support", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                  }),
                  _buildTile(context, Icons.security, "Privacy & Policy", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
                  }),
                  _buildTile(context, Icons.rule, "Terms And Conditions", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen()));
                  }),
                  _buildTile(context, Icons.receipt_long, "Refund Policy", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RefundPolicyScreen()));
                  }),
                  _buildTile(context, Icons.cancel_outlined, "Cancellation Policy", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CancellationPolicyScreen()));
                  }),
                ]),
                _buildSection(context, "Others", [
                  _buildTile(context, Icons.delete_outline, "Delete Account", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DeleteAccountScreen()));
                  }),
                  _buildTile(
                    context,
                    userSession.isLoggedIn ? Icons.logout : Icons.login,
                    userSession.isLoggedIn ? 'Sign Out' : 'Sign In',
                        () async {
                      if (!userSession.isLoggedIn) {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                        if (result == true) {
                          setState(() {}); // Optional, Provider will rebuild
                        }
                      } else {
                        showLogoutDialog(context, () async {
                          Navigator.pop(context); // close dialog
                          await userSession.logout(); // ✅ actual logout
                          setState(() {}); // Optional: to refresh UI if needed
                        });
                      }
                    },
                  )

                ])
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
          padding: const EdgeInsets.only(left: 15.0, bottom: 5),
          child: Text(title, style: textStyle14(context)),
        ),
        CustomContainer(
          border: true,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      leading: Icon(icon, color: Colors.black54, size: 22),
      title: Text(title, style: textStyle14(context)),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: CustomColor.iconColor),
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
      title: Text("Log Out", style: textStyle20(context, color: CustomColor.appColor)),
      content: const Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: textStyle14(context, color: Colors.red)),
        ),
        TextButton(
          onPressed: onConfirmLogout,
          child: Text("Log Out", style: textStyle14(context, color: CustomColor.appColor)),
        )
      ],
    ),
  );
}
