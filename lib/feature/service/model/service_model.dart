class ServiceModel {
  final String id;
  final String serviceName;
  final int? price;
  final num? discountedPrice;
  // final int? discountedPrice;
  final int? gst;
  final int? discount;
  final String thumbnailImage;
  final List<String> bannerImages;
  final List<String> tags;
  final Category category;
  final Subcategory? subcategory; // <-- made optional
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final List<KeyValue> keyValues;
  final List<ProviderPrice> providerPrices;

  /// rating
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final bool includeGst;


  ServiceModel({
    required this.id,
    required this.serviceName,
    this.price,
    this.discountedPrice,
    this.gst,
    this.discount,
    required this.thumbnailImage,
    required this.tags,
    required this.bannerImages,
    required this.category,
    this.subcategory,
    required this.serviceDetails,
    required this.franchiseDetails,
    required this.keyValues,
    required this.providerPrices,

    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
    required this.includeGst
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'],
      serviceName: json['serviceName'],
      price: json['price'] is int ? json['price'] : int.tryParse(json['price'].toString()),
      gst: json['gst'] is int ? json['gst'] : int.tryParse(json['gst'].toString()),
      discountedPrice: _parseNum(json['discountedPrice']),
      // discountedPrice: json['discountedPrice'] is int ? json['discountedPrice'] : int.tryParse(json['discountedPrice'].toString()),
      discount: json['discount'] is int ? json['discount'] : int.tryParse(json['discount'].toString()),
      thumbnailImage: json['thumbnailImage'],
      bannerImages: List<String>.from(json['bannerImages'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      category: Category.fromJson(json['category']),
      subcategory: json['subcategory'] != null ? Subcategory.fromJson(json['subcategory']) : null,
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails']),
      franchiseDetails: FranchiseDetails.fromJson(json['franchiseDetails']),
      keyValues: json['keyValues'] != null
          ? List<KeyValue>.from(json['keyValues'].map((x) => KeyValue.fromJson(x)))
          : [],
      providerPrices: json['providerPrices'] != null
          ? List<ProviderPrice>.from(json['providerPrices'].map((x) => ProviderPrice.fromJson(x)))
          : [],

      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'],
      recommendedServices: json['recommendedServices'],
      includeGst: json['includeGst'],
    );
  }
  static num? _parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }
}

class Category {
  final String id;
  final String name;
  final String module;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.module,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      module: json['module'],
      image: json['image'],
    );
  }
}
class ProviderPrice {
  final ServiceProvider? provider;
  final int? providerPrice;
  final String? providerCommission;  // changed to String? to accept "10%"
  final String? providerDiscount;    // new field
  final String? providerMRP;         // new field
  final String status;
  final String id;

  ProviderPrice({
    this.provider,
    this.providerPrice,
    this.providerCommission,
    this.providerDiscount,
    this.providerMRP,
    required this.status,
    required this.id,
  });

  factory ProviderPrice.fromJson(Map<String, dynamic> json) {
    return ProviderPrice(
      provider: json['provider'] != null ? ServiceProvider.fromJson(json['provider']) : null,
      providerPrice: json['providerPrice'] is int
          ? json['providerPrice']
          : int.tryParse(json['providerPrice']?.toString() ?? ''),
      providerCommission: json['providerCommission']?.toString(),
      providerDiscount: json['providerDiscount']?.toString(),
      providerMRP: json['providerMRP']?.toString(),
      status: json['status'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class ServiceProvider {
  final String id;
  final String fullName;

  ServiceProvider({
    required this.id,
    required this.fullName,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}


class ServiceDetails {
  final String overview;
  final List<String> highlight;
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
      highlight: List<String>.from(json['highlight'] ?? []),
      benefits: json['benefits'],
      howItWorks: json['howItWorks'],
      termsAndConditions: json['termsAndConditions'],
      document: json['document'],
      whyChoose: (json['whyChoose'] as List?)
          ?.map((x) => WhyChoose.fromJson(x))
          .toList() ??
          [],
      faq: (json['faq'] as List?)
          ?.map((x) => Faq.fromJson(x))
          .toList() ??
          [],
      extraSections: (json['extraSections'] as List?)
          ?.map((x) => ExtraSection.fromJson(x))
          .toList() ??
          [],
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
      extraSections: (json['extraSections'] as List?)
          ?.map((x) => ExtraSection.fromJson(x))
          .toList() ??
          [],
    );
  }
}

class ExtraSection {
  final String title;
  final String? description;
  final String id;

  ExtraSection({
    required this.title,
    this.description,
    required this.id,
  });

  factory ExtraSection.fromJson(Map<String, dynamic> json) {
    return ExtraSection(
      title: json['title'] ?? '',
      description: json['description'],
      id: json['_id'],
    );
  }
}

class WhyChoose {
  final String? title;
  final String? description;
  final String? image;
  final List<ExtraSection> extraSections;
  final String id;

  WhyChoose({
    this.title,
    this.description,
    this.image,
    this.extraSections = const [],
    required this.id,
  });

  factory WhyChoose.fromJson(Map<String, dynamic> json) {
    return WhyChoose(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      id: json['_id'],
      extraSections: (json['extraSections'] as List?)
          ?.map((x) => ExtraSection.fromJson(x))
          .toList() ??
          [],
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

class KeyValue {
  final String key;
  final String value;
  final String id;

  KeyValue({
    required this.key,
    required this.value,
    required this.id,
  });

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
      key: json['key'],
      value: json['value'],
      id: json['_id'],
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
