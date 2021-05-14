import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode/barcode.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);

    return Scaffold(
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
                      onPressed: () {},
                      child: Text("Shop"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
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
