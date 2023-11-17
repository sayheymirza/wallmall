// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:wallmall/core/theme.dart';
import 'package:wallmall/views/categories.dart';
import 'package:wallmall/views/category.dart';
import 'package:wallmall/views/color.dart';
import 'package:wallmall/views/colors.dart';
import 'package:wallmall/views/favorites.dart';
import 'package:wallmall/views/home.dart';
import 'package:wallmall/views/search.dart';
import 'package:wallmall/views/splash.dart';
import 'package:wallmall/views/wallpaper.dart';
import 'package:wallmall/views/page.dart' as Custom;
import 'package:wallmall/widgets/preview.dart';

import 'package:dynamic_color/dynamic_color.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        var _theme = theme;

        if (lightDynamic != null) {
          // replace light theme colors with _theme
          _theme = _theme.copyWith(
            colorScheme: lightDynamic,
          );
        }

        return MaterialApp(
          title: "WallMall",
          debugShowCheckedModeBanner: false,
          theme: _theme,
          initialRoute: "/",
          routes: {
            '/': (_) => const SplashView(),
            "/_": (_) => const HomeView(),
            "/_/wallpaper": (_) => const WallpaperView(),
            "/_/wallpaper/preview": (_) => const PreviewView(),
            "/_/search": (_) => const SearchView(),
            "/_/search/category": (_) => const CategoryView(),
            "/_/search/color": (_) => const ColorView(),
            "/_/favorites": (_) => const FavoritesView(),
            "/_/categories": (_) => const CategoriesView(),
            "/_/colors": (_) => const ColorsView(),
            "/_/page": (_) => const Custom.PageView(),
          },
        );
      },
    );
  }
}
