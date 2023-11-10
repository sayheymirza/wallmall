import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallmall/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white.withOpacity(0.1),
    ),
  );

//Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  runApp(const App());
}
