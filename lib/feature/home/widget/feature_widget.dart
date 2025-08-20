import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/my_lead/screen/leads_screen.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:fetchtrue/feature/wallet/screen/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_event.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';
import '../../team_build/repository/my_team_repository.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_event.dart';
import '../../wallet/bloc/wallet_state.dart';

Widget featureWidget(String userId) {
  return Row(
    children:  [
      BlocProvider(
          create: (_) => WalletBloc()..add(FetchWallet(userId)),
          child: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return  _buildShimmer();
              } else if (state is WalletLoaded) {
                final wallet = state.wallet;
               return  Expanded(
                 child: _FeatureItem(
                   icon: Icons.wallet,
                   title: 'Wallet',
                   subtitle: '₹ ${wallet.balance}',
                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(userId: userId),)),
                 ),
               );
              } else if (state is WalletError) {
                return SizedBox.shrink();
                // return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ) ),

      BlocProvider(
        create: (context) =>
        MyTeamBloc(MyTeamRepository())..add(GetMyTeam(userId)),
        child: BlocBuilder<MyTeamBloc, MyTeamState>(
          builder: (context, state) {
            if (state is MyTeamLoading) {
              return  _buildShimmer();
            } else if (state is MyTeamLoaded) {
              // final team = state.myTeam.team;

              final team = state.myTeam.team
                  .where((member) => member.user.packageActive == true)
                  .toList();

              if (team.isEmpty) {
                return  Expanded(
                  child: _FeatureItem(
                    icon: Icons.groups,
                    title: 'Team Build',
                    subtitle: '00',
                  ),
                );
              }

              return   Expanded(
                child: _FeatureItem(
                  icon: Icons.groups,
                  title: 'Team Build',
                  subtitle: '${team.length}',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamBuildScreen(userId: userId),)),
                ),
              );
            } else if (state is MyTeamError) {
              print('team Build error : ${state.message}');
              return SizedBox.shrink();
            }
            return const SizedBox();
          },
        ),
      ),
    ],
  );
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _FeatureItem({Key? key, required this.icon, required this.title, required this.subtitle, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      border: true,
      color: Colors.white,
       onTap: onTap,
      margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 25.4,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(icon, color: CustomColor.appColor),
            ),
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle14(context, fontWeight: FontWeight.w400)),
              Text(subtitle, style: textStyle14(context, color: CustomColor.appColor)),
            ],
          ),
        ],
      ),
    );
  }
}


Widget _buildShimmer(){
  return Expanded(child: CustomContainer(
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: Colors.white,radius: 25,),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(height: 10, width: 100),
              10.height,
              ShimmerBox(height: 10, width: 30),
            ],
          ),
        ],
      ),
    ),
  ));
}