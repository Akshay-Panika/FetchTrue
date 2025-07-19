import 'package:fetchtrue/feature/extra_earning/screen/extra_earning_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/firebase_uth/PhoneNumberScreen.dart';
import '../../team_build/bloc/non_gp/non_gp_bloc.dart';
import '../../team_build/bloc/non_gp/non_gp_event.dart';
import '../../team_build/bloc/non_gp/non_gp_state.dart';
import '../../team_build/repository/non_gp_service.dart';
import '../../team_build/screen/team_build_screen.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_event.dart';
import '../../wallet/bloc/wallet_state.dart';
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
                Expanded(child:  TeamBuildWidget(userId: userId,),),
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
  bool _isWalletFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isWalletFetched && widget.userId != null) {
      _fetchWallet();
      _isWalletFetched = true;
    }
  }

  void _fetchWallet() {
    context.read<WalletBloc>().add(FetchWalletByUser(widget.userId!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is WalletLoading) {
          return _buildShimmerEffect();
        }
        String earningsText = '₹ 00';

        if (widget.userId == null) {
          earningsText = '₹ 00';
        } else if (state is WalletLoaded) {
          final totalCredits = state.wallet.totalCredits ?? 0;
          earningsText = '₹ $totalCredits';
        } else if (state is WalletError) {
          earningsText = '₹ 00';
        }

        return CustomContainer(
          assetsImg: 'assets/image/totalEarningBackImg.jpg',
          height: double.infinity,
          margin: const EdgeInsets.only(left: 10),
          border: true,
          backgroundColor: CustomColor.whiteColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletScreen(userId: widget.userId ?? ''),
              ),
            ).then((_) {
              // अगर userId null नहीं है तब ही fetch करो
              if (widget.userId != null) {
                _fetchWallet();
              }
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/lead/total_earning_icon.png',
                  fit: BoxFit.contain,
                ),
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
                        text: earningsText,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: CustomColor.appColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CustomContainer(
        height: double.infinity,
        margin: const EdgeInsets.only(left: 10),
        border: true,
        backgroundColor: CustomColor.whiteColor,
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
      // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExtraEarningScreen(),)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/lead/my_lead_icon.jpg',),

          // Text('Extra Earning\nTask 50',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),)

          RichText(
            text: TextSpan(
              children: [
                TextSpan(text:'Extra Earning : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                TextSpan(text:'₹ 00', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: CustomColor.appColor),),
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
  final String? userId;
  const TeamBuildWidget({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NonGpBloc(NonGpService())..add(FetchNonGpLeads(userId ?? '')),
      child: BlocBuilder<NonGpBloc, NonGpState>(
        builder: (context, state) {
          if (state is NonGpLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }

          if (state is NonGpLoaded) {
            final totalCount = state.totalCount;

            return CustomContainer(
              assetsImg: 'assets/image/teamLeadBackImg.jpg',
              width: double.infinity,
              margin: const EdgeInsets.only(right: 10),
              border: true,
              backgroundColor: CustomColor.whiteColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamBuildScreen(userId: userId ?? ''),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Team Build : ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${totalCount ?? 0}'.padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: CustomColor.appColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset('assets/lead/team_lead_icon.png'),
                ],
              ),
            );
          }

          if (state is NonGpError) {
            return Center(child: Text(state.message));
          }

          return SizedBox.shrink(); // fallback
        },
      ),
    );
  }
}