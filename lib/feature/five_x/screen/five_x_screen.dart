import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/five_x/FiveXBloc.dart';
import '../bloc/five_x/FiveXEvent.dart';
import '../bloc/five_x/FiveXState.dart';
import '../model/FiveXModel.dart';
import '../repository/FiveXRepository.dart';


class FiveXScreen extends StatelessWidget {
  const FiveXScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '5X Guarantee',showBackButton: true,),

      body:BlocProvider(
        create: (_) => FiveXBloc(FiveXRepository())..add(FetchFiveX()),
        child: BlocBuilder<FiveXBloc, FiveXState>(
          builder: (context, state) {
            if (state is FiveXLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FiveXLoaded) {

              final data = state.data.first;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressCard(data),
                      SizedBox(height: 16),
                      _buildTimelineCard(context),
                      SizedBox(height: 16),
                      _buildFinancialInfoCard(context),
                      SizedBox(height: 16),
                      _buildExtraBenefitsCard(),
                      SizedBox(height: 16),
                      _buildEarningHistoryCard(),
                    ],
                  ),
                ),
              );
            } else if (state is FiveXError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Press button to fetch data"));
          },
        )
      ),
    );
  }

  Widget _buildProgressCard(FiveXModel? fiveX) {
    return CustomContainer(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('9 May 2025', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Icon(Icons.card_giftcard, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('Package Activated', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              SizedBox(width: 8),
              Spacer(),
              _buildLegend(),
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CustomPaint(
                    painter: CircularProgressPainter(),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '1X',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Current Level',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
            SizedBox(width: 4),
            Text('Earning Target-5Lakh', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
            SizedBox(width: 4),
            Text('Lead Target-900', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineCard(BuildContext context) {
    return CustomContainer(
      color: WidgetStateColor.transparent,
      child: Column(
        children: [
          LinearProgressIndicator(value: 0,color: CustomColor.appColor,),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Completed Months - 31', style: textStyle12(context,fontWeight: FontWeight.w400)),
              Text('Remaining Months - 05', style: textStyle12(context,fontWeight: FontWeight.w400))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInfoCard(BuildContext context) {
    return CustomContainer(
      color: CustomColor.whiteColor,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFinancialItem(context,'Franchise Fees', '₹10,000'),
              _buildFinancialItem(context,'Franchise Deposit', '₹1,00,000'),
              _buildFinancialItem(context,'Grand Total', '₹1,10,000'),
            ],
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('We Assure Return Current', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('Value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              Text('1X = ₹1,00,000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CustomColor.appColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialItem(BuildContext context,String label, String amount) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(amount, style:textStyle12(context, color: CustomColor.appColor)),
      ],
    );
  }

  Widget _buildExtraBenefitsCard() {
    return CustomContainer(
      color: CustomColor.whiteColor,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Extra Benefits',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CustomColor.appColor),
          ),

          Text(
            'You\'ve received ₹3,000 as your fixed monthly earning bonus for purchasing the package.',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningHistoryCard() {
    return CustomContainer(
      margin: EdgeInsets.zero,
      color: CustomColor.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Earning History',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...List.generate(7, (index) => _buildEarningItem(index + 1)),
        ],
      ),
    );
  }

  Widget _buildEarningItem(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '$index.',
              style: TextStyle(color: CustomColor.appColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transaction ID: FTF000049', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                Text('10:00 AM on 30 Aug 2025', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Text('₹ 3,000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double center = size.width / 2;
    double radius = center - 20;

    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    Paint bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(Offset(center, center), radius, backgroundPaint);

    // Draw blue arc (10%)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      -1.5708, // Start from top
      0.628, // 10% of circle (2π * 0.1)
      false,
      bluePaint,
    );

    // Draw green arc (62%)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      -1.5708 + 0.628, // Start after blue arc
      3.896, // 62% of circle (2π * 0.62)
      false,
      greenPaint,
    );

    // Add percentage labels
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // 10% label
    textPainter.text = TextSpan(
      text: '10%',
      style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center + radius - 30, center - radius - 20));

    // 62% label
    textPainter.text = TextSpan(
      text: '62%',
      style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center - radius - 10, center + radius - 30));

    // ₹5000 label
    textPainter.text = TextSpan(
      text: '₹5000',
      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center - radius - 20, center - radius + 10));

    // 120 Leads label
    textPainter.text = TextSpan(
      text: '120 Leads',
      style: TextStyle(color: Colors.green, fontSize: 10),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center - 30, center + 60));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}