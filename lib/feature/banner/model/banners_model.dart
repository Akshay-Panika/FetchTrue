class BannerModel {
  final String id;
  final String page;
  final String file;
  final String selectionType;
  final String? screenCategory;
  final String? service;
  final ModuleModel? module;
  final SubCategoryModel? subcategory;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  BannerModel({
    required this.id,
    required this.page,
    required this.file,
    required this.selectionType,
    this.screenCategory,
    this.service,
    this.module,
    this.subcategory,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] ?? '',
      page: json['page'] ?? '',
      file: json['file'] ?? '',
      selectionType: json['selectionType'] ?? '',
      screenCategory: json['screenCategory'],
      service: json['service'],
      module: json['module'] != null ? ModuleModel.fromJson(json['module']) : null,
      subcategory: json['subcategory'] != null ? SubCategoryModel.fromJson(json['subcategory']) : null,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class ModuleModel {
  final String id;
  final String name;
  final String image;
  final int sortOrder;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  ModuleModel({
    required this.id,
    required this.name,
    required this.image,
    required this.sortOrder,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
