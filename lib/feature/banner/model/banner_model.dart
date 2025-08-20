import '../../subcategory/model/subcategory_model.dart';

class ModuleBannerModel {
  final String id;
  final String page;
  final String selectionType;
  final String service;
  final String file;
  final ModuleModel? module;
  final SubcategoryModel? subcategory;

  ModuleBannerModel({
    required this.id,
    required this.page,
    required this.selectionType,
    required this.service,
    required this.file,
    this.module,
    this.subcategory,
  });

  factory ModuleBannerModel.fromJson(Map<String, dynamic> json) {
    return ModuleBannerModel(
      id: json['_id'] ?? '',
      page: json['page'] ?? '',
      selectionType: json['selectionType'] ?? '',
      service: json['service'] ?? '',
      file: json['file'] ?? '',
      module: json['module'] != null ? ModuleModel.fromJson(json['module']) : null,
      subcategory: json['subcategory'] != null ? SubcategoryModel.fromJson(json['subcategory']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'page': page,
      'selectionType': selectionType,
      'service': service,
      'file': file,
      'module': module?.toJson(),
      'subcategory': subcategory?.toJson(),
    };
  }
}

class ModuleModel {
  final String id;
  final String name;
  final String image;

  ModuleModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
    };
  }
}

