// import sqflite
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:wallmall/models/category.dart';
import 'package:wallmall/models/color.dart';
import 'package:wallmall/models/wallpaper.dart';

class _Database {
  Database? _db;

  Future<void> init() async {
    String file = '${await getDatabasesPath()}/database.db';

    _db = await openDatabase(file, version: 1, onCreate: _onCreate);
  }

  // on create database
  Future<void> _onCreate(Database db, int version) async {
    // create favorite table from wallpaper model if table not exists
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorite (
        id INTEGER PRIMARY KEY,
        image TEXT,
        name TEXT
      )
    ''');

    // create page table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS page (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE,
        content TEXT
      )
    ''');

    // create wallpaper table to store json
    await db.execute('''
      CREATE TABLE IF NOT EXISTS wallpaper (
        id INTEGER PRIMARY KEY,
        json TEXT
      )
    ''');

    // create category table from category model if table not exists
    await db.execute('''
      CREATE TABLE IF NOT EXISTS category (
        id INTEGER PRIMARY KEY UNIQUE,
        name TEXT,
        image TEXT
      )
    ''');

    // create color table from color model if table not exists
    await db.execute('''
      CREATE TABLE IF NOT EXISTS color (
        id INTEGER PRIMARY KEY UNIQUE,
        name TEXT,
        value TEXT
      )
    ''');
  }

  // add to favorite
  Future<void> addToFavorite(WallpaperModel wallpaper) async {
    try {
      await _db!.insert('favorite', {
        'id': wallpaper.id,
        'image': wallpaper.image,
        'name': wallpaper.name,
      });
    } catch (e) {
      //
    }
  }

  // remove from favorite
  Future<void> removeFromFavorite(WallpaperModel wallpaper) async {
    try {
      await _db!.delete(
        'favorite',
        where: 'id = ?',
        whereArgs: [wallpaper.id],
      );
    } catch (e) {
      //
    }
  }

  // has favorite
  Future<bool> hasFavorite(WallpaperModel wallpaper) async {
    try {
      var result = await _db!.query(
        'favorite',
        where: 'id = ?',
        whereArgs: [wallpaper.id],
      );

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // list of favorites
  Future<List<WallpaperModel>> listFavorites() async {
    try {
      var result = await _db!.query('favorite');

      return result
          .map(
            (e) => WallpaperModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // get page by key
  Future<String?> getPage(String key) async {
    try {
      var result = await _db!.query(
        'page',
        where: 'key = ?',
        whereArgs: [key],
      );

      if (result.isEmpty) {
        return null;
      }

      return result.first['content'].toString();
    } catch (e) {
      return null;
    }
  }

  // set page by key
  Future<void> setPage(String key, String content) async {
    try {
      // check key exists then update else insert
      var result = await _db!.query(
        'page',
        where: 'key = ?',
        whereArgs: [key],
      );

      if (result.isEmpty) {
        await _db!.insert('page', {
          'key': key,
          'content': content,
        });
      } else {
        await _db!.update(
          'page',
          {
            'content': content,
          },
          where: 'key = ?',
          whereArgs: [key],
        );
      }
    } catch (e) {
      //
    }
  }

  // get wallpaper by id
  Future<WallpaperModel?> getWallpaper(int id) async {
    try {
      var result = await _db!.query(
        'wallpaper',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null;
      }

      return WallpaperModel.fromJson(
        jsonDecode(
          result.first['json']! as String,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // get wallpapers
  Future<List<WallpaperModel>> getWallpapers() async {
    try {
      var result = await _db!.query('wallpaper');

      return result
          .map(
            (e) => WallpaperModel.fromJson(
              jsonDecode(
                e['json']! as String,
              ),
            ),
          )
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // set wallpapers
  Future<void> setWallpapers(List<WallpaperModel> wallpapers) async {
    try {
      // delete all wallpapers
      await _db!.delete('wallpaper');

      // insert wallpapers
      for (var wallpaper in wallpapers) {
        print("Caching wallpaper");
        await _db!.insert('wallpaper', {
          'id': wallpaper.id,
          'json': jsonEncode(
            wallpaper.toJson(),
          ),
        });
      }
    } catch (e) {
      print(e);
      //
    }
  }

  // get categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      var result = await _db!.query('category');

      return result
          .map(
            (e) => CategoryModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // set categories
  void setCategories(List<CategoryModel> categories) async {
    try {
      // delete all categories
      await _db!.delete('category');

      // insert categories
      for (var category in categories) {
        await _db!.insert('category', {
          'id': category.id,
          'name': category.name,
          'image': category.image,
        });
      }
    } catch (e) {
      //
    }
  }

  // get colors
  Future<List<ColorModel>> getColors() async {
    try {
      var result = await _db!.query('color');

      return result
          .map(
            (e) => ColorModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // set colors
  void setColors(List<ColorModel> colors) async {
    try {
      // delete all colors
      await _db!.delete('color');

      // insert colors
      for (var color in colors) {
        await _db!.insert('color', {
          'id': color.id,
          'name': color.name,
          'value': color.value,
        });
      }
    } catch (e) {
      //
    }
  }
}

// ignore: non_constant_identifier_names, library_private_types_in_public_api
_Database database = _Database();
