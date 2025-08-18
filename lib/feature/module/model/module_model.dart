class ModuleModel {
  final int sortOrder;
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final int v;
  final int categoryCount;

  ModuleModel({
    required this.sortOrder,
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.categoryCount,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      sortOrder: json['sortOrder'] ?? 0,
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      categoryCount: json['categoryCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sortOrder': sortOrder,
      '_id': id,
      'name': name,
      'image': image,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'categoryCount': categoryCount,
    };
  }
}
