import 'package:flutter/material.dart';
import 'package:scan_in/shop/shop.dart';
import 'alerts.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
  int index = 0;
  Featured({required this.index});
}

class _FeaturedState extends State<Featured> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return widget.index == 2
        ? Alerts(
            backToTabs: false,
          )
        : widget.index == 1
            ? Shop(
                goBack: false,
              )
            : Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: data.size.height * 0.05),
                        child: Center(
                          child: Text(
                            "Fitness Factory",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: data.size.height * 0.1),
                      ),
                      Container(
                        width: data.size.height * 0.3,
                        padding: EdgeInsets.all(20),
                        color: Colors.amber,
                        child: Text(
                            "Insert barcode type here from db (change colour to white)"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: data.size.height * 0.30),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.index = 1;
                                  setState(() {});
                                },
                                child: Text("Shop"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.index = 2;
                                  setState(() {});
                                },
                                child: Text("Alerts"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
