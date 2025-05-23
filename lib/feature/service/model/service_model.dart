// models/service_model.dart
class ServiceModel {
  final String id;
  final String serviceName;
  final int price;
  final String thumbnailImage;
  final List<String> bannerImages;
  final Subcategory subcategory;
  final ServiceDetails serviceDetails;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.thumbnailImage,
    required this.bannerImages,
    required this.subcategory,
    required this.serviceDetails,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'],
      serviceName: json['serviceName'],
      price: json['price'],
      thumbnailImage: json['thumbnailImage'],
      bannerImages: List<String>.from(json['bannerImages']),
      subcategory: Subcategory.fromJson(json['subcategory']),
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails']),
    );
  }
}

class ServiceDetails {
  final String overview;
  final String highlight;
  final String benefits;
  final String howItWorks;
  final String termsAndConditions;
  final String document;
  final List<ExtraSection> extraSections;
  final List<WhyChoose> whyChoose;
  final List<Faq> faq;

  ServiceDetails({
    required this.overview,
    required this.highlight,
    required this.benefits,
    required this.howItWorks,
    required this.termsAndConditions,
    required this.document,
    required this.extraSections,
    required this.whyChoose,
    required this.faq,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      overview: json['overview'],
      highlight: json['highlight'],
      benefits: json['benefits'],
      howItWorks: json['howItWorks'],
      termsAndConditions: json['termsAndConditions'],
      document: json['document'],
      extraSections: List<ExtraSection>.from(
        json['extraSections'].map((x) => ExtraSection.fromJson(x)),
      ),
      whyChoose: List<WhyChoose>.from(
        json['whyChoose'].map((x) => WhyChoose.fromJson(x)),
      ),
      faq: List<Faq>.from(json['faq'].map((x) => Faq.fromJson(x))),
    );
  }
}

class FranchiseDetails {
  final String overview;
  final String commission;
  final String howItWorks;
  final String termsAndConditions;
  final List<ExtraSection> extraSections;

  FranchiseDetails({
    required this.overview,
    required this.commission,
    required this.howItWorks,
    required this.termsAndConditions,
    required this.extraSections,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      overview: json['overview'],
      commission: json['commission'].toString(),
      howItWorks: json['howItWorks'],
      termsAndConditions: json['termsAndConditions'],
      extraSections: List<ExtraSection>.from(
        json['extraSections'].map((x) => ExtraSection.fromJson(x)),
      ),
    );
  }
}

class ExtraSection {
  final String title;
  final String description;
  final String id;

  ExtraSection({
    required this.title,
    required this.description,
    required this.id,
  });

  factory ExtraSection.fromJson(Map<String, dynamic> json) {
    return ExtraSection(
      title: json['title'],
      description: json['description'],
      id: json['_id'],
    );
  }
}

class WhyChoose {
  final String title;
  final String description;
  final String? image;
  final String id;

  WhyChoose({
    required this.title,
    required this.description,
    this.image,
    required this.id,
  });

  factory WhyChoose.fromJson(Map<String, dynamic> json) {
    return WhyChoose(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      id: json['_id'],
    );
  }
}

class Faq {
  final String question;
  final String answer;
  final String id;

  Faq({
    required this.question,
    required this.answer,
    required this.id,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'],
      answer: json['answer'],
      id: json['_id'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String module;
  final String image;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.module,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      module: json['module'],
      image: json['image'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Subcategory {
  final String id;
  final String name;
  final String category;

  Subcategory({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
    );
  }
}
