import 'package:fetchtrue/feature/extra_earning/screen/extra_earning_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/firebase_uth/PhoneNumberScreen.dart';
import '../../team_build/screen/team_build_screen.dart';
import '../../wallet/model/wallet_model.dart';
import '../../wallet/repository/wallet_service.dart';
import '../../wallet/screen/wallet_screen.dart';

class TETWidget extends StatelessWidget {
  final String? userId;
  const TETWidget({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return SizedBox(
      height: dimensions.screenHeight*0.15,
      child: Row(
        children: [
          Expanded(
            child: WalletWidget(userId: userId,),),
           10.width,

          Expanded(
            child: Column(
              children: [
                Expanded(child:  ExtraEarningWidget(),),
                10.height,
                Expanded(child:  TeamBuildWidget(),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



/// wallet
class WalletWidget extends StatefulWidget {
  final String? userId;
  const WalletWidget({super.key, this.userId});

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  WalletModel? _walletData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    if (widget.userId != null) {
      try {
        final wallet = await WalletService.fetchWalletByUser(widget.userId!);
        setState(() {
          _walletData = wallet;
          isLoading = false;
        });
      } catch (e) {
        print('Wallet fetch failed: $e');
        setState(() => isLoading = false);
      }
    } else {
      // No user ID, skip fetch
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    final totalEarning = _walletData?.totalCredits?.toStringAsFixed(2) ?? '0.00';

    return isLoading ?
    Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
        child: CustomContainer(
          backgroundColor: CustomColor.whiteColor,
          margin: const EdgeInsets.only(left: 10),
          height: dimensions.screenHeight*0.15,
        ),
      )
      :
      CustomContainer(
      assetsImg: 'assets/image/totalEarningBackImg.jpg',
      height: double.infinity,
      margin: const EdgeInsets.only(left: 10),
      border: true,
      backgroundColor: CustomColor.whiteColor,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WalletScreen(userId: widget.userId??'',)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset('assets/lead/total_earning_icon.png'),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Total Earning : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  TextSpan(
                    text: '₹ $totalEarning',
                    style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: CustomColor.appColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Extra Earning
class ExtraEarningWidget extends StatelessWidget {
  const ExtraEarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      assetsImg: 'assets/image/myLeadBackImg.jpg',
      width: double.infinity,
      margin: EdgeInsets.only(right: 10),
      border: true,
      backgroundColor: CustomColor.whiteColor,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExtraEarningScreen(),)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/lead/my_lead_icon.jpg',),

          // Text('Extra Earning\nTask 50',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),)

          RichText(
            text: TextSpan(
              children: [
                TextSpan(text:'Extra Earning : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                TextSpan(text:'₹ 50', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: CustomColor.appColor),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


/// Team Build
class TeamBuildWidget extends StatelessWidget {
  const TeamBuildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      assetsImg: 'assets/image/teamLeadBackImg.jpg',
      width: double.infinity,
      margin: EdgeInsets.only(right: 10),
      border: true,
      backgroundColor: CustomColor.whiteColor,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text:'Team Build : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                TextSpan(text:'50', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: CustomColor.appColor),),
              ],
            ),
          ),
          Image.asset('assets/lead/team_lead_icon.png',),
        ],
      ),
    );
  }
}
