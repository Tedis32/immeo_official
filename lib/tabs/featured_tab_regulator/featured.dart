import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:scan_in/services/database_service.dart';
import 'package:scan_in/shop/shop.dart';
import 'alerts.dart';
import 'package:scan_in/models/Barcode.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
  int index = 0;
  Featured({required this.index});
}

class _FeaturedState extends State<Featured> {
  List<BarcodeEntity> _featured = [];

  @override
  void initState() {
    super.initState();

    _loadFeaturedBarcode();
  }

  Future _loadFeaturedBarcode() async {
    DatabaseService.instance.getFeaturedBarcode().then((barcode) {
      setState(() {
        _featured.clear();
        _featured.add(barcode);
      });
    });
  }

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
                      _featured.isNotEmpty
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
                                    data: _featured.first.data,
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
