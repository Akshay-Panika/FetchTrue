class AdsModel {
  final bool success;
  final List<AdData> data;

  AdsModel({required this.success, required this.data});

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      success: json['success'],
      data: List<AdData>.from(json['data'].map((x) => AdData.fromJson(x))),
    );
  }
}

class AdData {
  final String id;
  final String addType;
  final Category category;
  final Service service;
  final String provider;
  final DateTime startDate;
  final DateTime endDate;
  final String title;
  final String description;
  final String? fileUrl;
  final bool isExpired;
  final bool isApproved;

  AdData({
    required this.id,
    required this.addType,
    required this.category,
    required this.service,
    required this.provider,
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.description,
    this.fileUrl,
    required this.isExpired,
    required this.isApproved,
  });

  factory AdData.fromJson(Map<String, dynamic> json) {
    return AdData(
      id: json['_id'],
      addType: json['addType'],
      category: Category.fromJson(json['category']),
      service: Service.fromJson(json['service']),
      provider: json['provider'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      title: json['title'],
      description: json['description'],
      fileUrl: json['fileUrl'],
      isExpired: json['isExpired'],
      isApproved: json['isApproved'],
    );
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

class Service {
  final String id;
  final String serviceName;
  final String category;
  final double price;
  final double discount;
  final double gst;
  final bool includeGst;
  final double gstInRupees;
  final double totalWithGst;
  final double discountedPrice;
  final String thumbnailImage;
  final List<String> bannerImages;
  final List<String> tags;
  final List<KeyValue> keyValues;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final bool isDeleted;
  final List<ProviderPrice> providerPrices;
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;

  Service({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    required this.discount,
    required this.gst,
    required this.includeGst,
    required this.gstInRupees,
    required this.totalWithGst,
    required this.discountedPrice,
    required this.thumbnailImage,
    required this.bannerImages,
    required this.tags,
    required this.keyValues,
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
    required this.isDeleted,
    required this.providerPrices,
    required this.serviceDetails,
    required this.franchiseDetails,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      serviceName: json['serviceName'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      gst: (json['gst'] as num).toDouble(),
      includeGst: json['includeGst'],
      gstInRupees: (json['gstInRupees'] as num).toDouble(),
      totalWithGst: (json['totalWithGst'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      thumbnailImage: json['thumbnailImage'],
      bannerImages: List<String>.from(json['bannerImages']),
      tags: List<String>.from(json['tags']),
      keyValues: List<KeyValue>.from(json['keyValues'].map((x) => KeyValue.fromJson(x))),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      recommendedServices: json['recommendedServices'],
      isDeleted: json['isDeleted'],
      providerPrices: List<ProviderPrice>.from(json['providerPrices'].map((x) => ProviderPrice.fromJson(x))),
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails']),
      franchiseDetails: FranchiseDetails.fromJson(json['franchiseDetails']),
    );
  }
}

class KeyValue {
  final String key;
  final String value;

  KeyValue({required this.key, required this.value});

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
      key: json['key'],
      value: json['value'],
    );
  }
}

class ProviderPrice {
  final String provider;
  final dynamic providerPrice;
  final String providerCommission;
  final String status;

  ProviderPrice({
    required this.provider,
    this.providerPrice,
    required this.providerCommission,
    required this.status,
  });

  factory ProviderPrice.fromJson(Map<String, dynamic> json) {
    return ProviderPrice(
      provider: json['provider'],
      providerPrice: json['providerPrice'],
      providerCommission: json['providerCommission'],
      status: json['status'],
    );
  }
}

class ServiceDetails {
  final String overview;
  final String benefits;
  final String howItWorks;
  final String termsAndConditions;
  final String document;
  final List<String> whyChoose;
  final List<Faq> faq;
  final List<String> highlight;
  final List<dynamic> extraSections;

  ServiceDetails({
    required this.overview,
    required this.benefits,
    required this.howItWorks,
    required this.termsAndConditions,
    required this.document,
    required this.whyChoose,
    required this.faq,
    required this.highlight,
    required this.extraSections,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      overview: json['overview'],
      benefits: json['benefits'],
      howItWorks: json['howItWorks'],
      termsAndConditions: json['termsAndConditions'],
      document: json['document'],
      whyChoose: List<String>.from(json['whyChoose']),
      faq: List<Faq>.from(json['faq'].map((x) => Faq.fromJson(x))),
      highlight: List<String>.from(json['highlight']),
      extraSections: json['extraSections'],
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
      commission: json['commission'],
      howItWorks: json['howItWorks'],
      termsAndConditions: json['termsAndConditions'],
      extraSections: List<ExtraSection>.from(
          json['extraSections'].map((x) => ExtraSection.fromJson(x))),
    );
  }
}

class ExtraSection {
  final String title;
  final String description;

  ExtraSection({required this.title, required this.description});

  factory ExtraSection.fromJson(Map<String, dynamic> json) {
    return ExtraSection(
      title: json['title'],
      description: json['description'],
    );
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'],
      answer: json['answer'],
    );
  }
}
