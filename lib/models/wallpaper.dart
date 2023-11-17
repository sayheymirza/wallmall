import 'package:wallmall/models/category.dart';
import 'package:wallmall/models/color.dart';
import 'package:wallmall/models/tag.dart';

class WallpaperModel {
  late int id;
  late String image;
  late String? name;
  late String? description;
  // categories string[]
  late List<CategoryModel> categories;
  // tags string[]
  late List<TagModel> tags;
  // release date
  late DateTime releasedAt;
  // size number
  late double size;
  // colors string[]
  late List<ColorModel> colors;

  WallpaperModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.categories,
    required this.tags,
    required this.releasedAt,
    required this.size,
    required this.colors,
  });

  // from json factory
  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      categories: json['categories']?.cast<CategoryModel>() ?? [],
      tags: json['tags']?.cast<TagModel>() ?? [],
      releasedAt: json['releasedAt'] != null
          ? DateTime.parse(json['releasedAt'])
          : DateTime.now(),
      size: json['size'] ?? 0.0,
      colors: json['colors']?.cast<ColorModel>() ?? [],
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
      'colors': colors,
    };
  }
}

class WallpapersResponseModel {
  late List<WallpaperModel> wallpapers;
  late int count;
  late int last;

  WallpapersResponseModel({
    required this.wallpapers,
    required this.count,
    required this.last,
  });

  // from json factory
  factory WallpapersResponseModel.fromJson(Map<String, dynamic> json) {
    return WallpapersResponseModel(
      wallpapers: json['wallpapers'],
      count: json['count'],
      last: json['last'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'wallpapers': wallpapers,
      'count': count,
      'last': last,
    };
  }
}
