import 'package:flutter/material.dart';
import 'package:wallmall/models/category.dart';
import 'package:wallmall/models/color.dart';

class ShareProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  set categories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  List<ColorModel> _colors = [];

  List<ColorModel> get colors => _colors;

  set colors(List<ColorModel> colors) {
    _colors = colors;
    notifyListeners();
  }

  // i18n
  String locale = "fa";

  void changeLocale(String locale) {
    this.locale = locale;
    notifyListeners();
  }
}
