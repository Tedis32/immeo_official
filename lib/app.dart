import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UI_stuff/AppTheme.dart';
import 'AppThemeNotifier.dart';
import 'tabs/homepage.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: HomePage());
      },
    );
  }
}
