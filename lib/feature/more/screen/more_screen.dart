import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/feature/checkout/screen/coupon_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../auth/screen/auth_screen.dart';
import '../../favorite/screen/favorite_screen.dart';
import '../../package/screen/package_screen.dart';
import '../../profile/screen/profile_screen.dart';
import '../../team_lead/screen/team_lead_screen.dart';
import '../../wallet/screen/wallet_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('___________________________________ Build More screen');

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile', showBackButton: false, showNotificationIcon: true,),
      
      body:  CustomScrollView(
        slivers: [

          SliverAppBar(
            floating: true,
            toolbarHeight: 120,
            backgroundColor: CustomColor.canvasColor,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(context),
            ),
          ),

          SliverToBoxAdapter(
            child:Column(
              children: [
                const SizedBox(height: 5),
                _buildSection("Account", [
                  _buildTile(context, Icons.person_outline, "Profile", () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),)),),
                  _buildTile(context, Icons.favorite_border, "Favorite", () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),)),),
                  _buildTile(context, Icons.wallet_outlined, "Wallet", () => Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(),)),),
                  _buildTile(context, Icons.card_giftcard, "Package", () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),))),
                  _buildTile(context, Icons.escalator_warning_outlined, "Refer And Earn",() => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),),
                  _buildTile(context, Icons.local_offer_outlined, "Coupon",() => Navigator.push(context, MaterialPageRoute(builder: (context) => CouponScreen(),)),),

                ]),
                const SizedBox(height: 5),
                _buildSection("Preferences", [
                  _buildTile(context, Icons.description_outlined, "About Us", () {}),
                  _buildTile(context, Icons.notifications_active_outlined, "Notifications", () {}),
                  _buildTile(context, Icons.settings_outlined, "Settings", () {}),
                  _buildTile(context, Icons.support_agent, "Help & Support", () {}),
                  _buildTile(context, Icons.security, "Privacy & Policy", () {}),
                  _buildTile(context, Icons.rule, "Terms And Conditions", () {}),
                  _buildTile(context, Icons.receipt_long, "Refund Policy", () {}),
                  _buildTile(context, Icons.cancel_outlined, "Cancellation Policy", () {}),
                ]),
                const SizedBox(height: 5),
                _buildSection("Others", [
                  _buildTile(context, Icons.delete_outline, "Delete Account", () {}),
                  _buildTile(context, Icons.logout, "Sign In", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(),));
                  }),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return CustomContainer(
      border: true,
     backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
      child: Row(
        children: [
           CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).cardColor,
             backgroundImage: AssetImage('assets/image/Null_Profile.jpg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("User Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("xyz@bizbooster.com", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          //Icon(Icons.edit, size: 16, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
        ),
       // const SizedBox(height: 8),
        CustomContainer(
          border: true,
         backgroundColor: Colors.white,
          padding: EdgeInsets.all(0),
          child: Column(children: children),
        )
      ],
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon,color: Colors.black54, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54,),
      onTap: onTap,
    );
  }

}
