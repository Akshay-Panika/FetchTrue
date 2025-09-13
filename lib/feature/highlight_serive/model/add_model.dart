class AdsResponse {
  final bool success;
  final List<AdsModel> data;

  AdsResponse({
    required this.success,
    required this.data,
  });

  factory AdsResponse.fromJson(Map<String, dynamic> json) {
    return AdsResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AdsModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AdsModel {
  final String id;
  final String addType;
  final Category category;
  final Service service;
  final Provider provider;
  final String startDate;
  final String endDate;
  final String title;
  final String description;
  final String fileUrl;
  final bool isExpired;
  final bool isApproved;

  AdsModel({
    required this.id,
    required this.addType,
    required this.category,
    required this.service,
    required this.provider,
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.isExpired,
    required this.isApproved,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json['_id'] ?? '',
      addType: json['addType'] ?? '',
      category: Category.fromJson(json['category']),
      service: Service.fromJson(json['service']),
      provider: Provider.fromJson(json['provider']),
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      isExpired: json['isExpired'] ?? false,
      isApproved: json['isApproved'] ?? false,
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
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      module: json['module'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Service {
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final String id;
  final String serviceName;
  final int price;
  final int discount;
  final int gst;
  final bool includeGst;
  final int gstInRupees;
  final int totalWithGst;
  final int discountedPrice;
  final String thumbnailImage;
  final List<String> bannerImages;
  final List<String> tags;

  Service({
    required this.serviceDetails,
    required this.franchiseDetails,
    required this.id,
    required this.serviceName,
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
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails']),
      franchiseDetails: FranchiseDetails.fromJson(json['franchiseDetails']),
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      includeGst: json['includeGst'] ?? false,
      gstInRupees: json['gstInRupees'] ?? 0,
      totalWithGst: json['totalWithGst'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      thumbnailImage: json['thumbnailImage'] ?? '',
      bannerImages: List<String>.from(json['bannerImages'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
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
  final List<String> whyChoose;
  final List<Faq> faq;

  ServiceDetails({
    required this.overview,
    required this.highlight,
    required this.benefits,
    required this.howItWorks,
    required this.termsAndConditions,
    required this.document,
    required this.whyChoose,
    required this.faq,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      overview: json['overview'] ?? '',
      highlight: List<String>.from(json['highlight'] ?? []),
      benefits: json['benefits'] ?? '',
      howItWorks: json['howItWorks'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
      document: json['document'] ?? '',
      whyChoose: List<String>.from(json['whyChoose'] ?? []),
      faq: (json['faq'] as List<dynamic>?)
          ?.map((e) => Faq.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class FranchiseDetails {
  final String overview;
  final String commission;
  final String howItWorks;
  final String termsAndConditions;

  FranchiseDetails({
    required this.overview,
    required this.commission,
    required this.howItWorks,
    required this.termsAndConditions,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      overview: json['overview'] ?? '',
      commission: json['commission'] ?? '',
      howItWorks: json['howItWorks'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
    );
  }
}

class Provider {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final StoreInfo storeInfo;

  Provider({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.storeInfo,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      storeInfo: StoreInfo.fromJson(json['storeInfo']),
    );
  }
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final String address;
  final String city;
  final String state;
  final String country;

  StoreInfo({
    required this.storeName,
    required this.storePhone,
    required this.storeEmail,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      storeName: json['storeName'] ?? '',
      storePhone: json['storePhone'] ?? '',
      storeEmail: json['storeEmail'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
