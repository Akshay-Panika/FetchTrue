import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_container.dart';
import '../../extra_earning/screen/extra_earning_screen.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_event.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';
import '../../team_build/repository/my_team_repository.dart';
import '../../team_build/screen/team_build_screen.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_event.dart';
import '../../wallet/bloc/wallet_state.dart';
import '../../wallet/screen/wallet_screen.dart';

class TETWidget extends StatelessWidget {
  final String? userId;
  const TETWidget({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Container(
      height: dimensions.screenHeight*0.15,
      margin: EdgeInsetsGeometry.only(top: 20),
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

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      assetsImg: 'assets/image/totalEarningBackImg.jpg',
      height: double.infinity,
      margin: const EdgeInsets.only(left: 10),
      border: true,
      color: CustomColor.whiteColor,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalletScreen(userId: widget.userId ?? ''),
          ),
        );
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
          BlocProvider(
              create: (_) => WalletBloc()..add(FetchWallet(widget.userId!)),
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoading) {
                    return  Align(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Total Earning: ',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            TextSpan(
                              text: '00',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: CustomColor.appColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is WalletLoaded) {
                    final wallet = state.wallet;
                    return  Align(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Total Earning : ',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            TextSpan(
                              text: '${formatPrice(wallet.balance)}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: CustomColor.appColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is WalletError) {
                    return SizedBox.shrink();
                    // return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ) )
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
      color: CustomColor.whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/lead/my_lead_icon.jpg',),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(text:'Extra Earning : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                TextSpan(text:'00', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: CustomColor.appColor),),
              ],
            ),
          )
        ],
      ),
      
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExtraEarningScreen(),)),
    );
  }
}


/// Team Build
class TeamBuildWidget extends StatelessWidget {
  final String? userId;
  const TeamBuildWidget({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      assetsImg: 'assets/image/teamLeadBackImg.jpg',
      width: double.infinity,
      margin: const EdgeInsets.only(right: 10),
      border: true,
      color: CustomColor.whiteColor,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamBuildScreen(userId: userId ?? ''),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          BlocProvider(
            create: (context) =>
            MyTeamBloc(MyTeamRepository())..add(GetMyTeam(userId!)),
            child: BlocBuilder<MyTeamBloc, MyTeamState>(
              builder: (context, state) {
                if (state is MyTeamLoading) {
                  return  RichText(
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
                          text: '${00}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: CustomColor.appColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is MyTeamLoaded) {
                  // final team = state.myTeam.team;

                  final team = state.myTeam.team
                      .where((member) => member.user.packageActive == true)
                      .toList();

                  if (team.isEmpty) {
                    return  RichText(
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
                            text: '${00}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: CustomColor.appColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return  RichText(
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
                          text: '${team.length}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: CustomColor.appColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is MyTeamError) {
                  return Text('Error: ${state.message}');
                }
                return const SizedBox();
              },
            ),
          ),
          Image.asset('assets/lead/team_lead_icon.png'),
        ],
      ),
    );
  }
}