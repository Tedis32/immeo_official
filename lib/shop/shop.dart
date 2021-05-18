import 'package:flutter/material.dart';
import 'package:scan_in/tabs/featured_tab_regulator/featured.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
  bool goBack;
  Shop({required this.goBack});
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return widget.goBack == true
        ? Featured(index: 0)
        : Scaffold(
            body: Center(
            child: TextButton(
              child: Text("Go back!"),
              onPressed: () {
                widget.goBack = true;
                setState(() {});
              },
            ),
          ));
  }
}
