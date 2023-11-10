import 'package:flutter/material.dart';
import 'package:wallmall/core/theme.dart';
import 'package:wallmall/views/home.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WallMall",
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: "/_",
      routes: {
        "/_": (_) => const HomeView(),
      },
    );
  }
}
