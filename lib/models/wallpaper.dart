class WallpaperModel {
  late int id;
  late String image;
  late String name;
  late String description;
  // categories string[]
  late List<String> categories;
  // tags string[]
  late List<String> tags;
  // release date
  late DateTime releasedAt;
  // size number
  late int size;

  WallpaperModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.categories,
    required this.tags,
    required this.releasedAt,
    required this.size,
  });

  // from json factory
  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      categories: json['categories'].cast<String>(),
      tags: json['tags'].cast<String>(),
      releasedAt: DateTime.parse(json['releasedAt']),
      size: json['size'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'description': description,
      'categories': categories,
      'tags': tags,
      'releasedAt': releasedAt.toIso8601String(),
      'size': size,
    };
  }
}
