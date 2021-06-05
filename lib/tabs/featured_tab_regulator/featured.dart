import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scan_in/providers/barcodeStore.dart';
import 'package:scan_in/services/database_service.dart';
import 'package:scan_in/shop/shop.dart';
import 'alerts.dart';
import 'package:scan_in/entities/BarcodeEntity.dart';

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
    final store = Provider.of<BarcodeStore>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Featured",
          style: TextStyle(
              fontFamily: GoogleFonts.shadowsIntoLight().fontFamily,
              fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            store.hasFeatured
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Fitness Factory",
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        child: BarcodeWidget(
                          data: store.featured.data,
                          barcode: Barcode.code128(),
                          height: 250,
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    child: Text('No Barcode is currently featured'),
                    padding: EdgeInsets.all(20),
                  ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
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
