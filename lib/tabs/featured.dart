import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:scan_in/database_helpers.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  List<Barcode> _barcodesList = [];

  @override
  void initState() {
    super.initState();

    _loadBarcodes();
  }

  Future _loadBarcodes() async {
    DatabaseHelper.instance.loadAll().then((barcodes) {
      setState(() {
        // Empty _barcodesList
        _barcodesList.clear();
        // Add barcodes to barcodes list from local database
        barcodes.forEach((element) {
          _barcodesList.add(element);
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

  Widget _buildPopupDialog(BuildContext context, int bcIndex) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_barcodesList[bcIndex].data),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add AnimatedList to show barcode additions and removals
    return RefreshIndicator(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _barcodesList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_barcodesList[index].id.toString()),
            subtitle: Text(_barcodesList[index].data),
            trailing: IconButton(
              icon: Icon(Icons.delete_rounded),
              onPressed: () => {_delete(_barcodesList[index].id)},
            ),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupDialog(context, index),
            ),
          );
        },
      ),
      onRefresh: _loadBarcodes,
    );
  }
}
