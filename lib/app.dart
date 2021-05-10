import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'authentication/homepage.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.black),
        fontFamily: GoogleFonts.roboto(fontWeight: FontWeight.normal).fontFamily,
      ),
    );
  }
}
