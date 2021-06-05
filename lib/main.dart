import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scan_in/providers/barcodeStore.dart';

import 'AppThemeNotifier.dart';
import 'app.dart';


void main() {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppThemeNotifier>(
          create: (context) => AppThemeNotifier(),
        ),
        ChangeNotifierProvider<BarcodeStore>(
          create: (_) => BarcodeStore(),
        )
      ],
      child: App(),
    ));
  });
}
