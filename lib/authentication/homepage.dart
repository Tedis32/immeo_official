import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scan_in/tabs/barcodes.dart';
import 'package:scan_in/tabs/featured.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tabs = [
    Featured(),
    Barcodes(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? Text("Featured",
                style:
                    TextStyle(fontFamily: GoogleFonts.sacramento().fontFamily))
            : Text(
                "Barcodes",
                style:
                    TextStyle(fontFamily: GoogleFonts.sacramento().fontFamily, fontSize: 25),
              ),
      ),
      body: IndexedStack(children: tabs, index: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber[600],
        unselectedItemColor: Colors.white54,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Featured",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Barcodes",
            backgroundColor: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),
    );
  }
}
