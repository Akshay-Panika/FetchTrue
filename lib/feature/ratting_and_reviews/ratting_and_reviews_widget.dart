import 'package:flutter/material.dart';
import 'package:fetchtrue/feature/ratting_and_reviews/repository/ratting_and_reviews_service.dart';
import 'model/retting_and_reviews_model.dart';

class RattingAndReviewsWidget extends StatefulWidget {
  final String? serviceId;
  final Color? color;

  const RattingAndReviewsWidget({
    super.key,
    this.serviceId,
    this.color,
  });

  @override
  State<RattingAndReviewsWidget> createState() => _RattingAndReviewsWidgetState();
}

class _RattingAndReviewsWidgetState extends State<RattingAndReviewsWidget> {
  late Future<ReviewResponse?> _futureReviews;

  @override
  void initState() {
    super.initState();
    if (widget.serviceId != null && widget.serviceId!.isNotEmpty) {
      _futureReviews = ReviewService().fetchReviews(widget.serviceId!);
    } else {
      _futureReviews = Future.value(null); // serviceId is invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReviewResponse?>(
      future: _futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("⭐ ...", style: TextStyle(fontSize: 12, color: widget.color ?? Colors.black));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text("⭐ N/A", style: TextStyle(fontSize: 12, color: widget.color ?? Colors.black));
        }

        final data = snapshot.data!;
        final rating = data.averageRating.toStringAsFixed(1);
        final total = data.totalReviews;
        final reviewText = total == 1 ? "Review" : "Reviews";

        return Text(
          '⭐ $rating ($total $reviewText)',
          style: TextStyle(fontSize: 12, color: widget.color ?? Colors.black),
        );
      },
    );
  }
}
