import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

class ReviewBarGraph extends StatelessWidget {
  final Map<int, int> ratings; // Example: {1: 2, 2: 4, 3: 5, 4: 3, 5: 6}

  const ReviewBarGraph({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarGraphPainter(ratings),
      ),
    );
  }
}

class _BarGraphPainter extends CustomPainter {
  final Map<int, int> ratings;
  _BarGraphPainter(this.ratings);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final barWidth = size.width / (ratings.length * 2); // spacing

    final maxValue = ratings.values.reduce((a, b) => a > b ? a : b);

    int index = 0;
    ratings.forEach((star, value) {
      final x = barWidth + index * 2 * barWidth;
      final barHeight = (value / maxValue) * size.height;
      final y = size.height - barHeight;

      paint.color = Colors.blueAccent;

      // Draw bar
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), paint);

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$star⭐',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x + barWidth / 2 - textPainter.width / 2, size.height + 5));

      index++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class ServiceReviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Anika Srishty",
      "rating": 5.0,
      "comment": "Your service is excellent",
      "date": "23 Jan, 2023",
    },
    {
      "name": "Anika Srishty",
      "rating": 5.0,
      "comment": "Great job",
      "date": "23 Jan, 2023",
    },
    {
      "name": "Anika Srishty",
      "rating": 5.0,
      "comment": "Great services",
      "date": "23 Jan, 2023",
    },
    {
      "name": "Anika Srishty",
      "rating": 4.0,
      "comment": "Excellent service",
      "date": "23 Jan, 2023",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Service Review', showBackButton: true,),
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ratingSummary(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text("4 Reviews", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 10),
          ...reviews.map((review) => reviewCard(review)).toList(),
        ],
      )),
    );
  }

  Widget ratingSummary() {
    return CustomContainer(
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 16,),
              SizedBox(width: 4),
              Text("4.75 / 5", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Spacer(),
              Text("4 Ratings", style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          SizedBox(height: 10),
          ratingBar("Excellent", 3),
          ratingBar("Good", 1),
          ratingBar("Average", 0),
          ratingBar("Below Average", 0),
          ratingBar("Poor", 0),
        ],
      ),
    );
  }

  Widget ratingBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 14),)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 3,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 6,
            ),
          ),
          SizedBox(width: 10),
          Text(value.toString()),
        ],
      ),
    );
  }

  Widget reviewCard(Map<String, dynamic> review) {
    return CustomContainer(
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(CustomImage.nullImage), // Replace with your own image or use NetworkImage
            radius: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(review['name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    Spacer(),
                    Text(review['date'], style: TextStyle(color: Colors.grey.shade700,fontSize: 14)),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Row(
                      children: List.generate(5,
                            (index) => Icon(
                          index < review['rating'].round()
                              ? Icons.star
                              : Icons.star_border, size: 14, color: Colors.blue,),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text('4.0')
                  ],
                ),
                SizedBox(height: 4),
                Text(review['comment'], style: TextStyle(fontSize: 12),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}