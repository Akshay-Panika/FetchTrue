import 'module_model.dart';

class ModuleCategoryModel {
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ModuleModel? module; // ✅ This is important

  ModuleCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.module,
  });

  factory ModuleCategoryModel.fromJson(Map<String, dynamic> json) {
    return ModuleCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      module: json['module'] != null ? ModuleModel.fromJson(json['module']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'module': module?.toJson(),
    };
  }
}
