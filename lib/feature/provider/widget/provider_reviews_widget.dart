import 'package:fetchtrue/feature/provider/model/provider_review_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_container.dart';
import '../repository/provider_review_service.dart';

class ProviderReviewsWidget extends StatefulWidget {
  final String? providerId;
  const ProviderReviewsWidget({super.key, this.providerId});

  @override
  State<ProviderReviewsWidget> createState() => _ProviderReviewsWidgetState();
}

class _ProviderReviewsWidgetState extends State<ProviderReviewsWidget> {
  late Future<ProviderReviewResponse?> _futureReviewResponse;

  @override
  void initState() {
    super.initState();
    _futureReviewResponse = ProviderReviewService().fetchReviews(widget.providerId!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProviderReviewResponse?>(
      future: _futureReviewResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Center(child: CircularProgressIndicator(color: CustomColor.appColor,),),
          );

        } else if (!snapshot.hasData || snapshot.data == null) {
          return Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: const Center(child: Text('No reviews found.')));
        }

        final data = snapshot.data!;
        final ratingDist = data.ratingDistribution;
        final reviews = data.reviews;
        final max = ratingDist.values.fold<int>(1, (a, b) => a > b ? a : b);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ratingSummary(data, ratingDist, max),
              const SizedBox(height: 20),
              Text("${reviews.length} Reviews", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              ...reviews.map((review) => reviewCard(review)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget ratingSummary(ProviderReviewResponse data, Map<int, int> dist, int max) {
    final labels = ['Excellent', 'Good', 'Average', 'Below Average', 'Poor'];
    final ratingMap = {
      5: dist[5] ?? 0,
      4: dist[4] ?? 0,
      3: dist[3] ?? 0,
      2: dist[2] ?? 0,
      1: dist[1] ?? 0,
    };

    return CustomContainer(
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text("${data.averageRating.toStringAsFixed(2)} / 5", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text("${data.totalReviews} Ratings", style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < labels.length; i++)
            ratingBar(labels[i], ratingMap[5 - i] ?? 0, max: max),
        ],
      ),
    );
  }

  Widget ratingBar(String label, int value, {required int max}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: LinearProgressIndicator(
              value: max == 0 ? 0 : value / max,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 6,
            ),
          ),
          const SizedBox(width: 10),
          Text(value.toString()),
        ],
      ),
    );
  }

  Widget reviewCard(Review review) {
    return CustomContainer(
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(CustomImage.nullImage),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.userEmail.split('@')[0],
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      review.createdAt.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      size: 14,
                      color: Colors.blue,
                    ),
                  )..add(const SizedBox(width: 5))
                    ..add(Text(review.rating.toString())),
                ),
                const SizedBox(height: 4),
                Text(review.comment, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
