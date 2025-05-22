/// ModuleModel.dart
class ModuleModel {
  final String id;
  final String name;
  final String image;
  final int categoryCount;

  ModuleModel({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryCount,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      categoryCount: json['categoryCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'categoryCount': categoryCount,
    };
  }
}

