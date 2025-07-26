import 'package:flutter/material.dart';
import '../model/offer_model.dart';
import '../repository/offer_service.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  String fixImageUrl(String url) {
    if (url.startsWith('/uploads/')) {
      return "https://biz-booster.vercel.app$url";
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offers")),
      body: FutureBuilder<List<OfferModel>>(
        future: OfferService.fetchOffers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final offers = snapshot.data!;
          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      fixImageUrl(offer.bannerImage),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Text("Image not found"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("🎯 Service: ${offer.serviceName}",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text("📅 Start: ${offer.offerStartTime}"),
                          Text("⏳ End: ${offer.offerEndTime}"),
                          const SizedBox(height: 8),
                          Text("✅ Eligibility: ${offer.eligibilityCriteria}"),
                          const SizedBox(height: 6),
                          Text("🛠 How to Participate:\n${offer.howToParticipate}"),
                          const SizedBox(height: 8),
                          Text("📷 Gallery:", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: offer.galleryImages.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Image.network(
                                    fixImageUrl(offer.galleryImages[i]),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("❓ FAQ:", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ...offer.faq.map((faq) => ListTile(
                            title: Text("Q: ${faq.question}"),
                            subtitle: Text("A: ${faq.answer}"),
                          )),
                          const SizedBox(height: 6),
                          Text("📜 Terms:\n${offer.termsAndConditions}"),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
