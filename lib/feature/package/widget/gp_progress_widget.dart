import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/material.dart';

class GpProgressWidget extends StatelessWidget {
  final String userId;
  final int targetCount;
  final int currentCount; // naya

  const GpProgressWidget({
    super.key,
    required this.userId,
    this.targetCount = 10,
    this.currentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentCount / targetCount).clamp(0.0, 1.0);
    final remaining = (targetCount - currentCount).clamp(0, targetCount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(CustomColor.greenColor),
            ),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _labelBox(context, "$currentCount", CustomColor.greyColor),
              _labelBox(context, "$targetCount", CustomColor.greenColor),
            ],
          ),
          15.height,
          Text(
            remaining > 0
                ? 'Almost there! Build your team with just $remaining more partners, you’ll become a SGP.'
                : '🎉 Congratulations! You have completed your team and become a SGP!',
            style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
          ),
          10.height,
        ],
      ),
    );
  }
}

Widget _labelBox(BuildContext context, String text, Color activeColor) {
  return Container(
    height: 22,
    width: 22,
    decoration: BoxDecoration(
      color: activeColor,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  );
}