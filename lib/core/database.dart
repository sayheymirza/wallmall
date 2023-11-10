// import sqflite
import 'package:sqflite/sqflite.dart';
import 'package:wallmall/models/wallpaper.dart';

class _Database {
  late Database _db;

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
        name TEXT,
        description TEXT,
        categories TEXT,
        tags TEXT,
        releasedAt TEXT,
        size INTEGER
      )
    ''');
  }

  // add to favorite
  Future<void> addToFavorite(WallpaperModel wallpaper) async {
    await _db.insert('favorite', wallpaper.toJson());
  }

  // remove from favorite
  Future<void> removeFromFavorite(WallpaperModel wallpaper) async {
    await _db.delete(
      'favorite',
      where: 'id = ?',
      whereArgs: [wallpaper.id],
    );
  }
}

// ignore: non_constant_identifier_names, library_private_types_in_public_api
_Database database = _Database();
