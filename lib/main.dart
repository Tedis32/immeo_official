import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scan_in/providers/barcodeStore.dart';
import 'package:scan_in/providers/google_sign_in.dart';

import 'AppThemeNotifier.dart';
import 'app.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
        ),
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
