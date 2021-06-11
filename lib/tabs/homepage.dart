import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scan_in/providers/google_sign_in.dart';
import 'package:scan_in/tabs/barcodes.dart';
import 'package:scan_in/tabs/featured_tab_regulator/featured.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tabs = [
    Featured(index: 0),
    Barcodes(),
  ];
  late ThemeData themeData;

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text("Logout"),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logOut();
            },
          )
        ],
        title: _currentIndex == 0
            ? Text("Featured",
                style: TextStyle(
                    fontFamily: GoogleFonts.shadowsIntoLight().fontFamily,
                    fontSize: 30))
            : Text(
                "Barcodes",
                style: TextStyle(
                    fontFamily: GoogleFonts.shadowsIntoLight().fontFamily,
                    fontSize: 30),
              ),
      ),
      body: IndexedStack(children: tabs, index: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: themeData.bottomAppBarTheme.color,
        selectedIconTheme: IconThemeData(color: themeData.primaryColor),
        selectedItemColor: themeData.primaryColor,
        unselectedIconTheme:
            IconThemeData(color: themeData.colorScheme.onBackground),
        unselectedItemColor: themeData.colorScheme.onBackground,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home), label: 'Featured'),
          BottomNavigationBarItem(
            icon: new Icon(Icons.code),
            label: 'Barcodes',
          )
        ],
      ),
    );
  }

  onTapped(value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
