import 'package:flutter/material.dart';
import 'package:scan_in/tabs/featured_tab_regulator/featured.dart';

class Alerts extends StatefulWidget {
  @override
  _AlertsState createState() => _AlertsState();
  bool backToTabs;
  Alerts({required this.backToTabs});
}

class _AlertsState extends State<Alerts> {
  @override
  Widget build(BuildContext context) {
    return widget.backToTabs == false
        ? Scaffold(
            body: Center(
            child: TextButton(
              child: Text("Go back!"),
              onPressed: () {
                widget.backToTabs = true;
                setState(() {});
              },
            ),
          ))
        : Featured(
            index: 0,
          );
  }
}
