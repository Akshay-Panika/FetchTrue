class ModuleSubCategoryModel {
  final String id;
  final String name;
  final String image;
  final CategoryModel category;

  ModuleSubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
  });

  factory ModuleSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return ModuleSubCategoryModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      category: CategoryModel.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'category': category,
    };
  }
}

class CategoryModel {
  final String id;

  CategoryModel({
    required this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
    );
  }
}
