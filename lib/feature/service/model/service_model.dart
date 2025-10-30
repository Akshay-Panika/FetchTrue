//
// class ServiceModel {
//   final String id;
//   final String serviceName;
//   final num? price;
//   final num? discountedPrice;
//   final num? gst;
//   final num? discount;
//   final String thumbnailImage;
//   final List<String> bannerImages;
//   final List<String> tags;
//   final Category category;
//   final Subcategory? subcategory;
//   final ServiceDetails serviceDetails;
//   final FranchiseDetails franchiseDetails;
//   final List<KeyValue> keyValues;
//   final List<ProviderPrice> providerPrices;
//
//   /// rating
//   final num averageRating;
//   final num totalReviews;
//   final bool recommendedServices;
//   final bool includeGst;
//
//   ServiceModel({
//     required this.id,
//     required this.serviceName,
//     this.price,
//     this.discountedPrice,
//     this.gst,
//     this.discount,
//     required this.thumbnailImage,
//     required this.tags,
//     required this.bannerImages,
//     required this.category,
//     this.subcategory,
//     required this.serviceDetails,
//     required this.franchiseDetails,
//     required this.keyValues,
//     required this.providerPrices,
//     required this.averageRating,
//     required this.totalReviews,
//     required this.recommendedServices,
//     required this.includeGst,
//   });
//
//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['_id']?.toString() ?? '',
//       serviceName: json['serviceName']?.toString() ?? '',
//       price: _parseNum(json['price']),
//       gst: _parseNum(json['gst']),
//       discountedPrice: _parseNum(json['discountedPrice']),
//       discount: _parseNum(json['discount']),
//       thumbnailImage: json['thumbnailImage']?.toString() ?? '',
//       bannerImages: List<String>.from(json['bannerImages'] ?? []),
//       tags: List<String>.from(json['tags'] ?? []),
//       category: Category.fromJson(json['category']),
//       subcategory: json['subcategory'] != null
//           ? Subcategory.fromJson(json['subcategory'])
//           : null,
//       serviceDetails: ServiceDetails.fromJson(json['serviceDetails']),
//       franchiseDetails: FranchiseDetails.fromJson(json['franchiseDetails']),
//       keyValues: json['keyValues'] != null
//           ? List<KeyValue>.from(
//           json['keyValues'].map((x) => KeyValue.fromJson(x)))
//           : [],
//       providerPrices: json['providerPrices'] != null
//           ? List<ProviderPrice>.from(
//           json['providerPrices'].map((x) => ProviderPrice.fromJson(x)))
//           : [],
//       averageRating: _parseNum(json['averageRating']) ?? 0,
//       totalReviews: _parseNum(json['totalReviews']) ?? 0,
//       recommendedServices: json['recommendedServices'] ?? false,
//       includeGst: json['includeGst'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'serviceName': serviceName,
//       'price': price,
//       'discountedPrice': discountedPrice,
//       'gst': gst,
//       'discount': discount,
//       'thumbnailImage': thumbnailImage,
//       'bannerImages': bannerImages,
//       'tags': tags,
//       'category': category.toJson(),
//       'subcategory': subcategory?.toJson(),
//       'serviceDetails': serviceDetails.toJson(),
//       'franchiseDetails': franchiseDetails.toJson(),
//       'keyValues': keyValues.map((e) => e.toJson()).toList(),
//       'providerPrices': providerPrices.map((e) => e.toJson()).toList(),
//       'averageRating': averageRating,
//       'totalReviews': totalReviews,
//       'recommendedServices': recommendedServices,
//       'includeGst': includeGst,
//     };
//   }
//
//   static num? _parseNum(dynamic value) {
//     if (value == null) return null;
//     if (value is num) return value;
//     return num.tryParse(value.toString());
//   }
// }
//
// class Category {
//   final String id;
//   final String name;
//   final String module;
//   final String image;
//
//   Category({
//     required this.id,
//     required this.name,
//     required this.module,
//     required this.image,
//   });
//
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['_id'],
//       name: json['name'],
//       module: json['module'],
//       image: json['image'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'module': module,
//       'image': image,
//     };
//   }
// }
//
// class Subcategory {
//   final String id;
//   final String name;
//   final String category;
//
//   Subcategory({
//     required this.id,
//     required this.name,
//     required this.category,
//   });
//
//   factory Subcategory.fromJson(Map<String, dynamic> json) {
//     return Subcategory(
//       id: json['_id'],
//       name: json['name'],
//       category: json['category'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'category': category,
//     };
//   }
// }
//
// class ProviderPrice {
//   final ServiceProvider? provider;
//   final double? providerPrice;
//   final String? providerCommission;
//   final String? providerDiscount;
//   final String? providerMRP;
//   final String status;
//   final String id;
//
//   ProviderPrice({
//     this.provider,
//     this.providerPrice,
//     this.providerCommission,
//     this.providerDiscount,
//     this.providerMRP,
//     required this.status,
//     required this.id,
//   });
//
//   factory ProviderPrice.fromJson(Map<String, dynamic> json) {
//     return ProviderPrice(
//       provider: json['provider'] != null ? ServiceProvider.fromJson(json['provider']) : null,
//       providerPrice: (json['providerPrice'] is int)
//           ? (json['providerPrice'] as int).toDouble()
//           : (json['providerPrice'] as num?)?.toDouble(),
//       providerCommission: json['providerCommission']?.toString(),
//       providerDiscount: json['providerDiscount']?.toString(),
//       providerMRP: json['providerMRP']?.toString(),
//       status: json['status'] ?? '',
//       id: json['_id'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'provider': provider?.toJson(),
//       'providerPrice': providerPrice,
//       'providerCommission': providerCommission,
//       'providerDiscount': providerDiscount,
//       'providerMRP': providerMRP,
//       'status': status,
//       '_id': id,
//     };
//   }
// }
//
// class ServiceProvider {
//   final String id;
//   final String fullName;
//   final StoreInfo? storeInfo;
//
//   ServiceProvider({
//     required this.id,
//     required this.fullName,
//     this.storeInfo,
//   });
//
//   factory ServiceProvider.fromJson(Map<String, dynamic> json) {
//     return ServiceProvider(
//       id: json['_id'] ?? '',
//       fullName: json['fullName'] ?? '',
//       storeInfo: json['storeInfo'] != null ? StoreInfo.fromJson(json['storeInfo']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'fullName': fullName,
//       'storeInfo': storeInfo?.toJson(),
//     };
//   }
// }
//
// class StoreInfo {
//   final String storeName;
//   final String logo;
//
//   StoreInfo({
//     required this.storeName,
//     required this.logo,
//   });
//
//   factory StoreInfo.fromJson(Map<String, dynamic> json) {
//     return StoreInfo(
//       storeName: json['storeName'] ?? '',
//       logo: json['logo'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'storeName': storeName,
//       'logo': logo,
//     };
//   }
// }
//
// class ServiceDetails {
//   final String overview;
//   final List<String> highlight;
//   final String benefits;
//   final String howItWorks;
//   final String termsAndConditions;
//   final String document;
//   final List<ExtraSection> extraSections;
//   final List<WhyChoose> whyChoose;
//   final List<Faq> faq;
//
//   ServiceDetails({
//     required this.overview,
//     required this.highlight,
//     required this.benefits,
//     required this.howItWorks,
//     required this.termsAndConditions,
//     required this.document,
//     required this.extraSections,
//     required this.whyChoose,
//     required this.faq,
//   });
//
//   factory ServiceDetails.fromJson(Map<String, dynamic> json) {
//     return ServiceDetails(
//       overview: json['overview'],
//       highlight: List<String>.from(json['highlight'] ?? []),
//       benefits: json['benefits'],
//       howItWorks: json['howItWorks'],
//       termsAndConditions: json['termsAndConditions'],
//       document: json['document'],
//       whyChoose: (json['whyChoose'] as List?)?.map((x) => WhyChoose.fromJson(x)).toList() ?? [],
//       faq: (json['faq'] as List?)?.map((x) => Faq.fromJson(x)).toList() ?? [],
//       extraSections: (json['extraSections'] as List?)?.map((x) => ExtraSection.fromJson(x)).toList() ?? [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'overview': overview,
//       'highlight': highlight,
//       'benefits': benefits,
//       'howItWorks': howItWorks,
//       'termsAndConditions': termsAndConditions,
//       'document': document,
//       'extraSections': extraSections.map((e) => e.toJson()).toList(),
//       'whyChoose': whyChoose.map((e) => e.toJson()).toList(),
//       'faq': faq.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class FranchiseDetails {
//   final String overview;
//   final String commission;
//   final String howItWorks;
//   final String termsAndConditions;
//   final List<ExtraSection> extraSections;
//
//   FranchiseDetails({
//     required this.overview,
//     required this.commission,
//     required this.howItWorks,
//     required this.termsAndConditions,
//     required this.extraSections,
//   });
//
//   factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
//     return FranchiseDetails(
//       overview: json['overview'],
//       commission: json['commission'].toString(),
//       howItWorks: json['howItWorks'],
//       termsAndConditions: json['termsAndConditions'],
//       extraSections: (json['extraSections'] as List?)?.map((x) => ExtraSection.fromJson(x)).toList() ?? [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'overview': overview,
//       'commission': commission,
//       'howItWorks': howItWorks,
//       'termsAndConditions': termsAndConditions,
//       'extraSections': extraSections.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class ExtraSection {
//   final String? title;
//   final String? description;
//   final String id;
//
//   ExtraSection({
//     this.title,
//     this.description,
//     required this.id,
//   });
//
//   factory ExtraSection.fromJson(Map<String, dynamic> json) {
//     return ExtraSection(
//       title: json['title'],
//       description: json['description'],
//       id: json['_id'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       '_id': id,
//     };
//   }
// }
//
// class WhyChoose {
//   final String? title;
//   final String? description;
//   final String? image;
//   final List<ExtraSection> extraSections;
//   final String id;
//
//   WhyChoose({
//     this.title,
//     this.description,
//     this.image,
//     this.extraSections = const [],
//     required this.id,
//   });
//
//   factory WhyChoose.fromJson(Map<String, dynamic> json) {
//     return WhyChoose(
//       title: json['title'],
//       description: json['description'],
//       image: json['image'],
//       id: json['_id'],
//       extraSections: (json['extraSections'] as List?)?.map((x) => ExtraSection.fromJson(x)).toList() ?? [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'image': image,
//       '_id': id,
//       'extraSections': extraSections.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class Faq {
//   final String question;
//   final String answer;
//   final String id;
//
//   Faq({
//     required this.question,
//     required this.answer,
//     required this.id,
//   });
//
//   factory Faq.fromJson(Map<String, dynamic> json) {
//     return Faq(
//       question: json['question'],
//       answer: json['answer'],
//       id: json['_id'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'question': question,
//       'answer': answer,
//       '_id': id,
//     };
//   }
// }
//
// class KeyValue {
//   final String key;
//   final String value;
//   final String id;
//
//   KeyValue({
//     required this.key,
//     required this.value,
//     required this.id,
//   });
//
//   factory KeyValue.fromJson(Map<String, dynamic> json) {
//     return KeyValue(
//       key: json['key'],
//       value: json['value'],
//       id: json['_id'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'key': key,
//       'value': value,
//       '_id': id,
//     };
//   }
// }
//
//
// class ServiceResponse {
//   final bool success;
//   final List<ServiceModel> data;
//   final String newUpdatedAt;
//
//   ServiceResponse({
//     required this.success,
//     required this.data,
//     required this.newUpdatedAt,
//   });
//
//   factory ServiceResponse.fromJson(Map<String, dynamic> json) {
//     return ServiceResponse(
//       success: json['success'] ?? false,
//       data: (json['data'] as List<dynamic>).map((e) => ServiceModel.fromJson(e)).toList(),
//       newUpdatedAt: json['newUpdatedAt'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'data': data.map((e) => e.toJson()).toList(),
//       'newUpdatedAt': newUpdatedAt,
//     };
//   }
// }

// 📦 service_model.dart
// ✅ Updated & Optimized FetchTrue Service Model
// Null-safe, Type-safe, Crash-proof

class ServiceModel {
  final String id;
  final String serviceName;
  final num? price;
  final num? discountedPrice;
  final num? gst;
  final num? discount;
  final String thumbnailImage;
  final List<String> bannerImages;
  final List<String> tags;
  final Category category;
  final Subcategory? subcategory;
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final List<KeyValue> keyValues;
  final List<ProviderPrice> providerPrices;
  final num averageRating;
  final num totalReviews;
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
    required this.includeGst,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      price: _parseNum(json['price']),
      gst: _parseNum(json['gst']),
      discountedPrice: _parseNum(json['discountedPrice']),
      discount: _parseNum(json['discount']),
      thumbnailImage: json['thumbnailImage']?.toString() ?? '',
      bannerImages: List<String>.from(json['bannerImages'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: json['subcategory'] != null
          ? Subcategory.fromJson(json['subcategory'])
          : null,
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
      franchiseDetails: FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      keyValues: (json['keyValues'] is List)
          ? List<KeyValue>.from(
          json['keyValues'].map((x) => KeyValue.fromJson(x)))
          : [],
      providerPrices: (json['providerPrices'] is List)
          ? List<ProviderPrice>.from(
          json['providerPrices'].map((x) => ProviderPrice.fromJson(x)))
          : [],
      averageRating: _parseNum(json['averageRating']) ?? 0,
      totalReviews: _parseNum(json['totalReviews']) ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
      includeGst: json['includeGst'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serviceName': serviceName,
      'price': price,
      'discountedPrice': discountedPrice,
      'gst': gst,
      'discount': discount,
      'thumbnailImage': thumbnailImage,
      'bannerImages': bannerImages,
      'tags': tags,
      'category': category.toJson(),
      'subcategory': subcategory?.toJson(),
      'serviceDetails': serviceDetails.toJson(),
      'franchiseDetails': franchiseDetails.toJson(),
      'keyValues': keyValues.map((e) => e.toJson()).toList(),
      'providerPrices': providerPrices.map((e) => e.toJson()).toList(),
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'recommendedServices': recommendedServices,
      'includeGst': includeGst,
    };
  }

  static num? _parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }
}

// ---------------------- CATEGORY ----------------------

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
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      module: json['module']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'module': module,
    'image': image,
  };
}

// ---------------------- SUBCATEGORY ----------------------

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
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'category': category,
  };
}

// ---------------------- PROVIDER PRICE ----------------------

class ProviderPrice {
  final ServiceProvider? provider;
  final double? providerPrice;
  final String? providerCommission;
  final String? providerDiscount;
  final String? providerMRP;
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
      provider: json['provider'] != null
          ? ServiceProvider.fromJson(json['provider'])
          : null,
      providerPrice: (json['providerPrice'] is int)
          ? (json['providerPrice'] as int).toDouble()
          : (json['providerPrice'] as num?)?.toDouble(),
      providerCommission: json['providerCommission']?.toString(),
      providerDiscount: json['providerDiscount']?.toString(),
      providerMRP: json['providerMRP']?.toString(),
      status: json['status']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'provider': provider?.toJson(),
    'providerPrice': providerPrice,
    'providerCommission': providerCommission,
    'providerDiscount': providerDiscount,
    'providerMRP': providerMRP,
    'status': status,
    '_id': id,
  };
}

// ---------------------- SERVICE PROVIDER ----------------------

class ServiceProvider {
  final String id;
  final String fullName;
  final StoreInfo? storeInfo;

  ServiceProvider({
    required this.id,
    required this.fullName,
    this.storeInfo,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      storeInfo: json['storeInfo'] != null
          ? StoreInfo.fromJson(json['storeInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'fullName': fullName,
    'storeInfo': storeInfo?.toJson(),
  };
}

class StoreInfo {
  final String storeName;
  final String logo;

  StoreInfo({
    required this.storeName,
    required this.logo,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      storeName: json['storeName']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'storeName': storeName,
    'logo': logo,
  };
}

// ---------------------- SERVICE DETAILS ----------------------

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
      overview: json['overview']?.toString() ?? '',
      highlight: (json['highlight'] as List?)
          ?.map((e) => e is Map ? e['url'].toString() : e.toString())
          .toList() ??
          [],
      benefits: json['benefits']?.toString() ?? '',
      howItWorks: json['howItWorks']?.toString() ?? '',
      termsAndConditions: json['termsAndConditions']?.toString() ?? '',
      document: json['document']?.toString() ?? '',
      extraSections: (json['extraSections'] is List)
          ? (json['extraSections'] as List)
          .map((x) => ExtraSection.fromJson(x))
          .toList()
          : [],
      whyChoose: (json['whyChoose'] is List)
          ? (json['whyChoose'] as List)
          .map((x) => WhyChoose.fromJson(x))
          .toList()
          : [],
      faq: (json['faq'] is List)
          ? (json['faq'] as List).map((x) => Faq.fromJson(x)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'overview': overview,
    'highlight': highlight,
    'benefits': benefits,
    'howItWorks': howItWorks,
    'termsAndConditions': termsAndConditions,
    'document': document,
    'extraSections': extraSections.map((e) => e.toJson()).toList(),
    'whyChoose': whyChoose.map((e) => e.toJson()).toList(),
    'faq': faq.map((e) => e.toJson()).toList(),
  };
}

// ---------------------- FRANCHISE DETAILS ----------------------

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
      overview: json['overview']?.toString() ?? '',
      commission: json['commission']?.toString() ?? '',
      howItWorks: json['howItWorks']?.toString() ?? '',
      termsAndConditions: json['termsAndConditions']?.toString() ?? '',
      extraSections: (json['extraSections'] is List)
          ? (json['extraSections'] as List)
          .map((x) => ExtraSection.fromJson(x))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'overview': overview,
    'commission': commission,
    'howItWorks': howItWorks,
    'termsAndConditions': termsAndConditions,
    'extraSections': extraSections.map((e) => e.toJson()).toList(),
  };
}

// ---------------------- EXTRA SECTION ----------------------

class ExtraSection {
  final String? title;
  final String? description;
  final String id;

  ExtraSection({
    this.title,
    this.description,
    required this.id,
  });

  factory ExtraSection.fromJson(Map<String, dynamic> json) {
    return ExtraSection(
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    '_id': id,
  };
}

// ---------------------- WHY CHOOSE ----------------------

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
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      id: json['_id']?.toString() ?? '',
      extraSections: (json['extraSections'] is List)
          ? (json['extraSections'] as List)
          .map((x) => ExtraSection.fromJson(x))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'image': image,
    '_id': id,
    'extraSections': extraSections.map((e) => e.toJson()).toList(),
  };
}

// ---------------------- FAQ ----------------------

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
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    '_id': id,
  };
}

// ---------------------- KEY VALUE ----------------------

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
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
    '_id': id,
  };
}

// ---------------------- RESPONSE WRAPPER ----------------------

class ServiceResponse {
  final bool success;
  final List<ServiceModel> data;
  final String newUpdatedAt;

  ServiceResponse({
    required this.success,
    required this.data,
    required this.newUpdatedAt,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      success: json['success'] ?? false,
      data: (json['data'] is List)
          ? (json['data'] as List)
          .map((e) => ServiceModel.fromJson(e))
          .toList()
          : [],
      newUpdatedAt: json['newUpdatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((e) => e.toJson()).toList(),
    'newUpdatedAt': newUpdatedAt,
  };
}

