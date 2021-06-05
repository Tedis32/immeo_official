import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scan_in/app.dart';
import 'package:scan_in/tabs/featured_tab_regulator/featured.dart';
import '../main.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4),
          ),
          Row(
            children: [Text("Balance: ")],
          )
        ],
        title: Text(
          "Shop Around!",
          style: TextStyle(
              fontFamily: GoogleFonts.shadowsIntoLight().fontFamily,
              fontSize: 30),
        ),
      ),
      body: Center(),
    );
  }
}
