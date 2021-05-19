import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scan_in/models/Barcode.dart';
import 'package:scan_in/services/barcode_service.dart';
import 'package:scan_in/services/database_service.dart';

class Barcodes extends StatefulWidget {
  @override
  _BarcodesState createState() => _BarcodesState();
}

class _BarcodesState extends State<Barcodes> {
  List<Barcode> _barcodesList = [];

  @override
  void initState() {
    super.initState();

    _loadBarcodes();
  }

  Future _loadBarcodes() async {
    DatabaseService.instance.loadAll().then((barcodes) {
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
    DatabaseService helper = DatabaseService.instance;
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

  _scanNewBarcode() async {
    print('Button pressed');
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Exit Scanner", false, ScanMode.DEFAULT);

    print('Result: ' + barcodeScanRes);

    if (barcodeScanRes == '-1') {
      // User has closed barcode scanner
      barcodeScanRes = "example";
    }

    int iRows = await BarcodeService.addBarcode(barcodeScanRes);
    return iRows > 0;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add AnimatedList to show barcode additions and removals
    return RefreshIndicator(
      child: Column(
        children: <Widget>[
          _barcodesList.isEmpty
              ? (TextButton(
                  onPressed: _loadBarcodes,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: Colors.amber[600],
                        ),
                      ),
                      Text(
                        'Refresh Barcodes',
                        style: TextStyle(color: Colors.amber[600]),
                      )
                    ],
                  ),
                ))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
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
          TextButton(
            onPressed: _scanNewBarcode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.amber[600],
                  ),
                ),
                Text(
                  'Add new Barcode',
                  style: TextStyle(color: Colors.amber[600]),
                )
              ],
            ),
          ),
        ],
      ),
      onRefresh: _loadBarcodes,
    );
  }
}
