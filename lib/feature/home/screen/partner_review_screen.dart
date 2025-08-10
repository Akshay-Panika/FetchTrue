import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../model/partner_review_model.dart';
import '../repository/partner_review_service.dart';

class PartnerReviewVideoScreen extends StatefulWidget {
  const PartnerReviewVideoScreen({super.key});

  @override
  State<PartnerReviewVideoScreen> createState() =>
      _PartnerReviewVideoScreenState();
}

class _PartnerReviewVideoScreenState extends State<PartnerReviewVideoScreen> {
  late Future<PartnerReviewResponse> _futureReviews;

  @override
  void initState() {
    super.initState();
    _futureReviews = PartnerReviewService.getPartnerReviews();
  }

  String _extractVideoId(String url) {
    return YoutubePlayer.convertUrlToId(url) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PartnerReviewResponse>(
      future: _futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(child: Text("No reviews found"));
        }

        final reviews = snapshot.data!.data;

        return SizedBox(
          height: 250, // थोड़ height ज्यादा ताकि title भी fit हो
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final videoId = _extractVideoId(review.videoUrl);

              if (videoId.isEmpty) {
                return SizedBox.shrink();
              }

              final controller = YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );

              return CustomContainer(
                width: 150,
                 color: Colors.white,
                 padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: YoutubePlayer(
                        controller: controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.red,
                      ),
                    ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text( review.title),
                     )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
