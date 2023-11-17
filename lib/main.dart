import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallmall/app.dart';
import 'package:wallmall/core/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.white.withOpacity(0.1),
      systemNavigationBarDividerColor: Colors.white.withOpacity(0.1),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white.withOpacity(0.1),
    ),
  );

//Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ShareProvider(),
        ),
      ],
      child: const App(),
    ),
  );
}
