import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:scan_in/database_helpers.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  List<Barcode> barcodesList = [];

  @override
  void initState() {
    super.initState();

    _loadBarcodes();
  }

  Future _loadBarcodes() async {
    DatabaseHelper.instance.loadAll().then((barcodes) {
      setState(() {
        // Empty barcodesList
        barcodesList.clear();
        // Add barcodes to barcodes list from local database
        barcodes.forEach((element) {
          barcodesList.add(element);
        });
      });
    });
  }

  _delete(int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    bool deleted = await helper.deleteBarcodeByIndex(index);
    if (deleted) {
      print('barcode deleted');
      _loadBarcodes();
    } else {
      print('barcod not deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add AnimatedList to show barcode additions and removals
    return RefreshIndicator(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: barcodesList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.qr_code_rounded),
              onPressed: () => {log('Open QRCode $index')},
            ),
            title: Text(barcodesList[index].id.toString()),
            subtitle: Text(barcodesList[index].data),
            trailing: IconButton(
              icon: Icon(Icons.delete_rounded),
              onPressed: () => {_delete(barcodesList[index].id)},
            ),
          );
        },
      ),
      onRefresh: _loadBarcodes,
    );
  }
}
