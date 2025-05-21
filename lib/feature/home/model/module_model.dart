/// module model.dart

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
      id: json['_id'],
      name: json['name'],
      image: json['image'],
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

