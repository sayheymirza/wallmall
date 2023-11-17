import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.deepPurpleAccent,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  useMaterial3: true,
);
