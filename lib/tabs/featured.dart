import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

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
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily:
                          GoogleFonts.robotoMono(fontWeight: FontWeight.normal)
                              .fontFamily),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: data.size.height * 0.1),
            ),
            Container(
              child: BarCodeImage(
                padding: EdgeInsets.only(
                    left: data.size.width * 0.05,
                    right: data.size.width * 0.05),
                params: Code39BarCodeParams(
                  "MOCK39",
                  lineWidth:
                      2.0, // width for a single black/white bar (default: 2.0)
                  barHeight:
                      130.0, // height for the entire widget (default: 100.0)
                  withText:
                      true, // Render with text label or not (default: false)
                ),
                onError: (error) {
                  // Error handler
                  print('error = $error');
                },
              ),
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
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[800]),
                      ),
                      onPressed: () {},
                      child: Text("Shop"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[800]),
                      ),
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
