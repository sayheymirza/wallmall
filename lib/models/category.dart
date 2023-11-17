class CategoryModel {
  late int id;
  late String image;
  late String name;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
  });

  // from json factory
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
    };
  }
}
