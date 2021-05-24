import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:scan_in/entities/BarcodeEntity.dart';
import 'package:scan_in/providers/barcodeStore.dart';
import 'package:scan_in/services/barcode_service.dart';
import 'package:scan_in/services/database_service.dart';
import 'package:barcode/barcode.dart';

class Barcodes extends StatefulWidget {
  @override
  _BarcodesState createState() => _BarcodesState();
}

class _BarcodesState extends State<Barcodes> {
  late BarcodeEntity _selectedBarcode;
  late BarcodeStore store;

  void _scanNewBarcode() async {
    print('Button pressed');
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Exit Scanner", false, ScanMode.DEFAULT);

    print('Result: ' + barcodeScanRes);

    if (barcodeScanRes == '-1') {
      // User has closed barcode scanner
      // FIXME: Remove next line only for testing purposes
      barcodeScanRes = "abcd";
    }

    store.addBarcode(await BarcodeService.addBarcode(barcodeScanRes));
  }

  void _openViewBarcodeModal() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BarcodeWidget(
              data: _selectedBarcode.data,
              barcode: Barcode.code128(),
              height: 250,
              padding: EdgeInsets.all(10),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            )
          ],
        ),
      ),
    );
  }

  void _openEditBarcodeModal() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Edit Barcode'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red[800]),
                    onPressed: () {
                      store.removeBarcode(_selectedBarcode.id);
                      Navigator.pop(context);
                    },
                    child: Text('Delete "' + _selectedBarcode.title + '"'),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.star_border_rounded, color: Colors.amber[600]),
                onPressed: () => store.setFeaturedBarcode(_selectedBarcode.id),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BarcodeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: store.barcodes.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(store.barcodes[index].title),
          subtitle: Text(store.barcodes[index].data),
          leading: store.barcodes[index].featured == 1
              ? Icon(Icons.star_rounded)
              : null,
          trailing: IconButton(
            icon: Icon(Icons.edit_rounded),
            onPressed: () {
              setState(() {
                _selectedBarcode = store.barcodes[index];
              });
              _openEditBarcodeModal();
            },
          ),
          onTap: () {
            setState(() {
              _selectedBarcode = store.barcodes[index];
            });
            _openViewBarcodeModal();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    store = Provider.of<BarcodeStore>(context);
    // TODO: Add AnimatedList to show barcode additions and removals
    return Scaffold(
      body: RefreshIndicator(
        child: store.barcodes.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('It\'s empty here. Try adding a new barcode.'),
                ),
              )
            : BarcodeList(),
        onRefresh: store.refreshBarcodes,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanNewBarcode,
        label: Text(
          'Add new Barcode',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.camera_enhance_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
