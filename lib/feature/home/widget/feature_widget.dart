import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:fetchtrue/feature/wallet/screen/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_event.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_event.dart';
import '../../wallet/bloc/wallet_state.dart';

class FeatureWidget extends StatefulWidget {
  final String userId;
  const FeatureWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<FeatureWidget> createState() => _FeatureWidgetState();
}

class _FeatureWidgetState extends State<FeatureWidget> {

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(FetchWalletByUserId(widget.userId));
    context.read<MyTeamBloc>().add(FetchMyTeam(widget.userId));

  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    return Padding(
      padding:  EdgeInsets.only(top: dimensions.screenHeight*0.002),
      child: Row(
        children: [
          /// Wallet Balance
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return  _buildShimmer();
              } else if (state is WalletLoaded) {
                final wallet = state.wallet;
                return  _FeatureItem(
                  icon: Icons.wallet,
                  title: 'Wallet',
                  subtitle: '₹ ${wallet.balance}',
                  onTap: () => context.push('/wallet/${widget.userId}',),
                );
              } else if (state is WalletError) {
                return  _FeatureItem(
                  icon: Icons.wallet,
                  title: 'Wallet',
                  subtitle: '0.0',
                  onTap: () => context.push('/my-team'),
                );
              }
              return const SizedBox();
            },
          ),

          BlocBuilder<MyTeamBloc, MyTeamState>(
            builder: (context, state) {
              if (state is MyTeamLoading) {
                return  _buildShimmer();
              } else if (state is MyTeamLoaded) {
                // final teamList = state.response.team;
                final userCount = state.response.team.length;
                return _FeatureItem(
                  icon: CupertinoIcons.person_2_fill,
                  title: 'My Team',
                  subtitle: '$userCount', // show count
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeamBuildScreen()),
                  ),
                );
              } else if (state is MyTeamError) {
                print('"Error: ${state.message}"');
                return _FeatureItem(
                  icon: CupertinoIcons.person_2_fill,
                  title: 'My Team',
                  subtitle: '0', // fallback
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeamBuildScreen()),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _FeatureItem({Key? key, required this.icon, required this.title, required this.subtitle, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Expanded(
      child: CustomContainer(
        border: true,
        color: Colors.white,
         onTap: onTap,
        margin: EdgeInsetsGeometry.symmetric(horizontal: dimensions.screenHeight*0.010),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyle14(context, fontWeight: FontWeight.w400)),
                Text(subtitle, style: textStyle14(context, color: CustomColor.appColor)),
              ],
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Icon(icon, color: CustomColor.appColor))
          ],
        ),
      ),
    );
  }
}


Widget _buildShimmer(){
  return Expanded(child: CustomContainer(
    padding: EdgeInsets.all(15),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(height: 15, width: 100),
              10.height,
              ShimmerBox(height: 10, width: 30),
            ],
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: ShimmerBox(height: 25, width: 25)),
        ],
      ),
    ),
  ));
}