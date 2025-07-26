class OfferModel {
  final String id;
  final String bannerImage;
  final DateTime offerStartTime;
  final DateTime offerEndTime;
  final List<String> galleryImages;
  final String eligibilityCriteria;
  final String howToParticipate;
  final List<Faq> faq;
  final String termsAndConditions;
  final String serviceName;

  OfferModel({
    required this.id,
    required this.bannerImage,
    required this.offerStartTime,
    required this.offerEndTime,
    required this.galleryImages,
    required this.eligibilityCriteria,
    required this.howToParticipate,
    required this.faq,
    required this.termsAndConditions,
    required this.serviceName,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json["_id"],
      bannerImage: json["bannerImage"] ?? '',
      offerStartTime: DateTime.tryParse(json["offerStartTime"] ?? '') ?? DateTime.now(),
      offerEndTime: DateTime.tryParse(json["offerEndTime"] ?? '') ?? DateTime.now(),
      galleryImages: List<String>.from(json["galleryImages"] ?? []),
      eligibilityCriteria: json["eligibilityCriteria"] ?? '',
      howToParticipate: json["howToParticipate"] ?? '',
      faq: (json["faq"] as List<dynamic>?)
          ?.map((e) => Faq.fromJson(e))
          .toList() ??
          [],
      termsAndConditions: json["termsAndConditions"] ?? '',
      serviceName: json["service"]?["serviceName"] ?? '',
    );
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json["question"] ?? '',
      answer: json["answer"] ?? '',
    );
  }
}
