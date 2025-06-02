
class ModuleBannerModel {
  final String id;
  final String page;
  final String selectionType;
  final String file;
  final ModuleModel? module;
  // final SubcategoryModel? subcategory;

  ModuleBannerModel({
    required this.id,
    required this.page,
    required this.selectionType,
    required this.file,
    this.module,
    // this.subcategory,
  });

  factory ModuleBannerModel.fromJson(Map<String, dynamic> json) {
    return ModuleBannerModel(
      id: json['_id'],
      page: json['page'],
      selectionType: json['selectionType'],
      file: json['file'],
      module: ModuleModel.fromJson(json['module']),
      // subcategory: SubcategoryModel.fromJson(json['subcategory'])
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'page': page,
      'selectionType': selectionType,
      'file': file,
      'module':module,
      // 'subcategory':subcategory,
    };
  }
}


/// ModuleModel
class ModuleModel {
  final String? id;

  ModuleModel({
    this.id,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'],
    );
  }
}


/// SubcategoryModel
class SubcategoryModel {
  final String id;
  final String categoryId;

  SubcategoryModel({
    required this.id,
    required this.categoryId,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['_id'],
      categoryId: json['category'],
    );
  }
}