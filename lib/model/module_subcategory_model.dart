class ModuleSubCategoryModel {
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final Category category;

  ModuleSubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.category,
  });

  factory ModuleSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return ModuleSubCategoryModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      isDeleted: json['isDeleted'],
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'isDeleted': isDeleted,
      'category': category.toJson(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'module': module,
      'image': image,
    };
  }
}
