import 'package:bizbooster2x/feature/home/model/module_model.dart';

class ModuleBannerModel {
  final String id;
  final String page;
  final String selectionType;
  final String file;
  final Category? category;
  final SubCategory? subcategory;
  final ModuleModel? module;

  ModuleBannerModel({
    required this.id,
    required this.page,
    required this.selectionType,
    required this.file,
    this.category,
    this.subcategory,
    this.module,
  });

  factory ModuleBannerModel.fromJson(Map<String, dynamic> json) {
    return ModuleBannerModel(
      id: json['_id'] ?? '',
      page: json['page'] ?? '',
      selectionType: json['selectionType'] ?? '',
      file: json['file'] ?? '',
      category: json['category'] == null
          ? null
          : (json['category'] is String
          ? Category(id: json['category'], name: '') // only id available
          : Category.fromJson(json['category'])),
      subcategory: json['subcategory'] == null
          ? null
          : (json['subcategory'] is String
          ? SubCategory(id: json['subcategory'], name: '') // only id available
          : SubCategory.fromJson(json['subcategory'])),
       module: json['category'] != null ? ModuleModel.fromJson(json['category']) : null,

    );
  }

}

class Category {
  final String id;
  final String name;
  final String? module;
  final String? image;

  Category({
    required this.id,
    required this.name,
    this.module,
    this.image,
  });

  factory Category.fromJson(dynamic json) {
    // json can be Map or String
    if (json is String) {
      return Category(id: json, name: '');
    } else if (json is Map<String, dynamic>) {
      return Category(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        module: json['category'],
        image: json['image'],
      );
    } else {
      throw Exception('Invalid category json');
    }
  }
}

class SubCategory {
  final String id;
  final String name;
  final String? image;
  final bool? isDeleted;
  final String? category;

  SubCategory({
    required this.id,
    required this.name,
    this.image,
    this.isDeleted,
    this.category,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    // category inside subcategory can be String or Map
    Category? categoryObj;
    if (json['category'] != null) {
      categoryObj = Category.fromJson(json['category']);
    }

    return SubCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      isDeleted: json['isDeleted'],
      category: json['category'],
    );
  }
}
