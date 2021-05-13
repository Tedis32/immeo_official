import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database_helpers.dart';

class Barcodes extends StatefulWidget {
  @override
  _BarcodesState createState() => _BarcodesState();
}

class _BarcodesState extends State<Barcodes> {
  String _barcodeData;
  String _message = "No message to display to user";

  void scanNewBarcode() async {
    log('Button pressed');
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Exit Scanner", false, ScanMode.DEFAULT);

    log('Result: ' + barcodeScanRes);

    setState(() {
      _barcodeData = barcodeScanRes;
    });
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    Barcode bc = await helper.queryBarcode(rowId);
    if (bc == null) {
      print('read row $rowId: empty');
    } else {
      print('read row $rowId: ${bc.data}');

      setState(() {
        _barcodeData = bc.data;
        _message = "Barcode " + bc.data + " loaded from local database";
      });
    }
  }

  _save() async {
    if (_barcodeData == null) {}

    Barcode bc = Barcode();
    bc.data = _barcodeData;
    DatabaseHelper helper = DatabaseHelper.instance;

    int id = await helper.insert(bc);
    setState(() {
      _message = 'Barcode: $_barcodeData saved to local database with id: $id';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_message),
          ElevatedButton(
            child: Text('Read saved Barcode'),
            onPressed: () {
              _read();
            },
          ),
          ElevatedButton(
            child: Text('Save current Barcode'),
            onPressed: () {
              _save();
            },
          ),
          _barcodeData != null
              ? QrImage(
                  data: _barcodeData,
                  version: QrVersions.auto,
                  size: 250.0,
                )
              : Text("No barcode loaded."),
          TextButton(
            child: Text('Scan Barcode'),
            onPressed: () => {
              scanNewBarcode(),
            },
          )
        ],
      ),
    );
  }
}
