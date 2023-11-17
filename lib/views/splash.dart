import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallmall/api/api.dart';
import 'package:wallmall/core/connectivity.dart';
import 'package:wallmall/core/database.dart';
import 'package:wallmall/core/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // Wait for context to be ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() async {
    var provider = Provider.of<ShareProvider>(context, listen: false);

    await database.init();

    if (await connectivity.connected) {
      print("Online mode");
      // promise.all
      Future.wait([
        // get categories
        api.categories().then((categories) {
          provider.categories = categories;

          database.setCategories(categories);
        }),

        // get colors
        api.colors().then((colors) {
          provider.colors = colors;

          database.setColors(colors);
        }),
      ]).then((_) {
        Navigator.pushReplacementNamed(context, "/_");
      });
    } else {
      print("Offline mode");
      Future.wait([
        // get categories
        database.getCategories().then((categories) {
          provider.categories = categories;
        }),

        // get colors
        database.getColors().then((colors) {
          provider.colors = colors;
        }),
      ]).then((_) {
        Navigator.pushReplacementNamed(context, "/_");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
