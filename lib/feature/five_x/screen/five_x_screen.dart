import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_state.dart';
import '../../lead/model/lead_model.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/model/user_model.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_state.dart';
import '../../wallet/model/wallet_model.dart';
import '../bloc/five_x/FiveXBloc.dart';
import '../bloc/five_x/FiveXEvent.dart';
import '../bloc/five_x/FiveXState.dart';
import '../model/FiveXModel.dart';
import '../repository/FiveXRepository.dart';


class FiveXScreen extends StatelessWidget {
  const FiveXScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return Scaffold(
      appBar: CustomAppBar(title: '5X Guarantee',showBackButton: true,),

      body:BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {

          if (state is UserInitial) {
            context.read<UserBloc>().add(GetUserById(userSession.userId!));
            return   CircularProgressIndicator();
          }
          else if(state is UserLoading){
            return   CircularProgressIndicator();
          }
          else if (state is UserLoaded) {
            final user = state.user;
            return BlocBuilder<LeadBloc, LeadState>(
              builder: (context, state) {
                if (state is LeadLoading) {
                  return CircularProgressIndicator();
                } else if (state is LeadLoaded) {
                  final allLeads = state.leadModel.data ?? [];
                  final completedLeads = allLeads.where((e) => e.isCompleted == true).toList();

                  return BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      if (state is WalletLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is WalletLoaded) {
                        final wallet = state.wallet;
                        return  BlocBuilder<FiveXBloc, FiveXState>(
                          builder: (context, state) {
                            if (state is FiveXLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is FiveXLoaded) {

                              final data = state.data.first;
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      CustomContainer(
                                        border: true,
                                        color: Colors.blue.withOpacity(0.1),
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('📅  Package Activated:', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),),5.width,
                                            Text('${formatDateTime(user.packageActivateDate)}', style: textStyle12(context, fontWeight: FontWeight.w400,color: CustomColor.blackColor),),
                                          ],
                                        ),
                                      ),
                                      CustomContainer(
                                        color: CustomColor.whiteColor,
                                        margin: EdgeInsets.zero,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                           20.height,

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                _buildLevelProgressCard(context,data, completedLeads,user),
                                                _buildEarningProgressCard(context,data, completedLeads,user, wallet),
                                              ],
                                            ),
                                            10.height,

                                            _buildEligible(context,data, user),
                                          ],
                                        ),
                                      ),

                                      10.height,

                                      _buildLEL(context, data,completedLeads,wallet)
                                    ],
                                  ),
                                ),
                              );
                            } else if (state is FiveXError) {
                              return Center(child: Text(state.message));
                            }
                            return const Center(child: Text("Press button to fetch data"));
                          },
                        );
                      } else if (state is WalletError) {
                        print('Error: ${state.message}');
                        return SizedBox.shrink();
                      }
                      return const SizedBox();
                    },
                  );

                } else if (state is LeadError) {
                  print(state.message);
                }
                return SizedBox.shrink();
              },
            );
          } else if (state is UserError) {
            print('Error: ${state.massage}');

          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLevelProgressCard(BuildContext context, FiveXModel? fiveX, List<BookingData> completedLeads, UserModel user) {

    final lead = completedLeads.length; // Actual leads count
    final target = fiveX?.leadcount ?? 1; // Target leads
    final progress = (lead / target).clamp(0.0, 1.0);
    final percentage = ((lead / target) * 100).clamp(0, 100).toStringAsFixed(1);
    final xLevel = (progress * 5).round().clamp(0, 5);

    return Column(
      children: [
        Text('Level Progress', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.greenColor),),
        20.height,

        Stack(
          alignment: Alignment.center,
          children: [
            HalfCircleProgress(
              progress: progress,
              size: 140,
              backgroundColor: Colors.grey.shade300,
              progressColor: Colors.green,
            ),
            Text('${xLevel.toString()}X', style: textStyle12(context,color: CustomColor.greenColor),)
          ],
        ),

        Center(child: Text('Progress: $percentage%', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor))),

      ],
    );
  }
  Widget _buildEarningProgressCard(BuildContext context, FiveXModel? fiveX, List<BookingData> completedLeads, UserModel user,  WalletModel wallet) {
    final earning = wallet.balance ?? 0;
    final target = fiveX?.fixearning ?? 1;

    final progress = (earning / target).clamp(0.0, 1.0);

    final percentage = ((earning / target) * 100).clamp(0, 100).toStringAsFixed(1);

    return Column(
      children: [
        Text('Earning Progress', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),),
        20.height,

        Stack(
          alignment: Alignment.center,
          children: [
            HalfCircleProgress(
              progress: progress,
              size: 140,
              backgroundColor: Colors.grey.shade300,
              progressColor: CustomColor.appColor,
            ),
            Text('₹ ${wallet.balance}', style: textStyle12(context,color: CustomColor.appColor),)
          ],
        ),

        Center(child: Text('Progress: $percentage%', style: textStyle12(context, fontWeight: FontWeight.w400))),

      ],
    );
  }

  Widget _buildEligible(BuildContext context, FiveXModel? fiveX, UserModel user) {
    final createdAt = DateTime.parse(user.createdAt.toString());
    final targetMonths = fiveX?.months ?? 0;
    final now = DateTime.now();
    int completedMonths = (now.year - createdAt.year) * 12 + (now.month - createdAt.month);
    int remainingMonths = targetMonths - completedMonths;
    if (remainingMonths < 0) remainingMonths = 0;

    return CustomContainer(
      border: true,
      color: CustomColor.whiteColor,
      child: Text('⏳ Are you eligible? — Yes, Remaining $remainingMonths Months'),
    );
  }


  Widget _buildLEL(BuildContext context, FiveXModel? fiveX, List<BookingData> completedLeads, WalletModel wallet){
    final count = completedLeads.length ?? 0; // actual count
    final maxCount = fiveX?.leadcount ?? 1;
    final progress = (count / maxCount).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    final xLevel = (progress * 5).round().clamp(0, 5);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCard(context,'Current Level', '${xLevel}X', Colors.blue.shade50),
        _buildCard(context,'Total Earnings', '₹ ${wallet.balance}/${fiveX!.fixearning}', Colors.green.shade50),
        _buildCard(context,'Total Leads', '${completedLeads.length}/${fiveX.leadcount}', Colors.amber.shade50),
      ],
    );
  }

  Widget _buildCard(BuildContext context,String headline, String value, Color cardColor){
    return  CustomContainer(
      border: true,
      margin: EdgeInsets.zero,
      color: cardColor,
      child: Column(
        children: [
          Text(headline, style: textStyle12(context, fontWeight: FontWeight.w400),),
          Text(value, style: textStyle12(context),)
        ],
      ),
    );
  }
}

class HalfCircleProgress extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double size;
  final Color backgroundColor;
  final Color progressColor;

  const HalfCircleProgress({
    super.key,
    required this.progress,
    this.size = 80,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size / 2, // Half circle
      child: CustomPaint(
        painter: _HalfCirclePainter(
          progress: progress,
          backgroundColor: backgroundColor,
          progressColor: progressColor,
        ),
      ),
    );
  }
}

class _HalfCirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _HalfCirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final startAngle = -3.14; // start from left
    final sweepAngle = 3.14; // 180 degree half circle

    // Background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);

    // Progress
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
