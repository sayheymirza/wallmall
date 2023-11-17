// import http
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallmall/models/category.dart';
import 'package:wallmall/models/color.dart';
import 'package:wallmall/models/tag.dart';
import 'package:wallmall/models/wallpaper.dart';

class _Api {
  final String _endpoint = "https://strapi.heymirza.ir";
  final String _token =
      "2b2498332931f1f4dacc86b852723f674e34fe5bdc6182a99858d97401bf41055693138c86d682b64112ce7b43e0a6959e3281144814f09b54c7bcb3b6fa7ecefedb780b675b6a35281477f1ded9c994441059c007ce424031a61af485586fc5753aa9cf67994f722b29072dbe1e68c5e4da6653e87b50fef2edf5125ab86424";

  // get list of categories
  Future<List<CategoryModel>> categories({
    int page = 1,
  }) async {
    try {
      var uri = Uri.parse("$_endpoint/api/wallmall-categories");

      var response = await http.get(
        uri.replace(
          queryParameters: {
            "populate": "image",
            "pagination[page]": page.toString(),
            "pagination[pageSize]": "100",
          },
        ),
        headers: {
          "Authorization": "Bearer $_token",
        },
      );

      if (response.statusCode == 200) {
        // convert string body to json
        var json = jsonDecode(response.body);

        // convert json to list of categories
        var categories = json["data"].map<CategoryModel>((category) {
          String image = category["attributes"]["image"]["data"]["attributes"]
              ["formats"]["small"]["url"];

          return CategoryModel(
            id: category["id"],
            name: category["attributes"]["name"],
            image: "$_endpoint$image",
          );
        }).toList();

        return categories;
      }

      return [];
    } catch (e) {
      print(e);

      return [];
    }
  }

  // get list of colors
  Future<List<ColorModel>> colors({
    int page = 1,
  }) async {
    try {
      var uri = Uri.parse("$_endpoint/api/wallmall-colors");

      var response = await http.get(
        uri.replace(
          queryParameters: {
            "pagination[page]": page.toString(),
            "pagination[pageSize]": "100",
          },
        ),
        headers: {
          "Authorization": "Bearer $_token",
        },
      );

      if (response.statusCode == 200) {
        // convert string body to json
        var json = jsonDecode(response.body);

        // convert json to list of colors
        var colors = json["data"].map<ColorModel>((color) {
          return ColorModel(
            id: color["id"],
            value: color["attributes"]["value"],
            name: color["attributes"]["name"],
          );
        }).toList();

        return colors;
      }

      return [];
    } catch (e) {
      print("=== ERROR ===");
      print(e);

      return [];
    }
  }

  // get list of wallpapers
  Future<WallpapersResponseModel?> wallpapers({
    String q = "",
    int page = 1,
    int? category,
    int? color,
  }) async {
    dynamic queries = {
      "pagination[page]": page.toString(),
      "pagination[pageSize]": "10",
      "sort": "publishedAt:DESC",
      "populate": "image",
      "filters[device][\$eq]": "phone"
    };

    if (q.isNotEmpty) {
      // strapi filter name and description fields
      queries["filters[name][\$contains]"] = q;
    }

    // filter by category
    if (category != null) {
      queries["filters[wallmall_categories][id][\$eq]"] = category.toString();
      // populate category
      queries["populate"] = "image,wallmall_categories";
    }

    // filter by color
    if (color != null) {
      queries["filters[wallmall_colors][id][\$eq]"] = color.toString();
      // populate color
      queries["populate"] = "image,wallmall_colors";
    }

    try {
      var uri = Uri.parse("$_endpoint/api/wallmall-wallpapers");

      var response = await http.get(
        uri.replace(queryParameters: queries),
        headers: {
          "Authorization": "Bearer $_token",
        },
      );

      if (response.statusCode == 200) {
        // convert string body to json
        var json = jsonDecode(response.body);

        // convert json to list of wallpapers
        var wallpapers = json["data"]
            .map<dynamic>((wallpaper) {
              dynamic image = wallpaper["attributes"]["image"]["data"]
                  ["attributes"]["formats"];

              if (image["small"] != null) {
                image = image["small"]["url"];
              } else if (image["medium"] != null) {
                image = image["medium"]["url"];
              } else if (image["thumbnail"] != null) {
                image = image["thumbnail"]["url"];
              } else if (image["large"] != null) {
                image = image["large"]["url"];
              } else {
                return null;
              }

              return WallpaperModel(
                id: wallpaper["id"],
                name: wallpaper["attributes"]["name"],
                image: "$_endpoint$image",
                description: wallpaper["attributes"]["description"],
                categories: [],
                tags: [],
                releasedAt:
                    DateTime.parse(wallpaper["attributes"]["publishedAt"]),
                size: 0,
                colors: [],
              );
            })
            .where((w) => w != null)
            .toList();

        return WallpapersResponseModel(
          wallpapers: wallpapers.cast<WallpaperModel>(),
          count: json["meta"]["pagination"]["total"],
          last: json["meta"]["pagination"]["pageCount"],
        );
      }

      return null;
    } catch (e) {
      print("=== ERROR ===");
      print(e);

      return null;
    }
  }

  Future<WallpaperModel?> wallpaper({required int id}) async {
    try {
      var uri = Uri.parse("$_endpoint/api/wallmall-wallpapers/$id?populate=*");

      var response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $_token",
        },
      );

      if (response.statusCode == 200) {
        // convert string body to json
        var json = jsonDecode(response.body);

        dynamic image = json["data"]["attributes"]["image"]["data"]
            ["attributes"]["formats"];

        if (image["large"] != null) {
          image = image["large"];
        } else if (image["medium"] != null) {
          image = image["medium"];
        } else if (image["small"] != null) {
          image = image["small"];
        } else if (image["thumbnail"] != null) {
          image = image["thumbnail"];
        } else {
          image = image["small"];
        }

        var colors = json["data"]["attributes"]["wallmall_colors"]["data"]
            .map<ColorModel>((c) {
          return ColorModel(
            id: c["id"],
            value: c["attributes"]["value"],
            name: c["attributes"]["name"],
          );
        }).toList();

        var tags = json["data"]["attributes"]["wallmall_tags"]["data"]
            .map<TagModel>((t) {
          return TagModel(
            id: t["id"],
            text: t["attributes"]["text"],
          );
        }).toList();

        var categories = json["data"]["attributes"]["wallmall_categories"]
                ["data"]
            .map<CategoryModel>((c) {
          dynamic image = "";

          return CategoryModel(
            id: c["id"],
            name: c["attributes"]["name"],
            image: "$_endpoint$image",
          );
        }).toList();

        return WallpaperModel(
          id: json["data"]["id"],
          name: json["data"]["attributes"]["name"],
          image: _endpoint + image["url"],
          description: json["data"]["attributes"]["description"],
          categories: categories,
          tags: tags,
          releasedAt: DateTime.parse(json["data"]["attributes"]["publishedAt"]),
          size: image["size"],
          colors: colors,
        );
      }

      return null;
    } catch (e) {
      print("=== ERROR ===");
      print(e);

      return null;
    }
  }

  // get page
  Future<String?> page({required String key}) async {
    try {
      var uri = Uri.parse("$_endpoint/api/app-pages");

      var response = await http.get(
        uri.replace(
          queryParameters: {
            "filters[key][\$eq]": key,
            "filters[app][\$eq]": "wallmall"
          },
        ),
        headers: {
          "Authorization": "Bearer $_token",
        },
      );

      if (response.statusCode == 200) {
        // convert string body to json
        var json = jsonDecode(response.body);

        return json["data"][0]["attributes"]["content"];
      }

      return null;
    } catch (e) {
      print("=== ERROR ===");
      print(e);

      return null;
    }
  }
}

// ignore: library_private_types_in_public_api
_Api api = _Api();
