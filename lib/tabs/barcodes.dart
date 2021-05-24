import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scan_in/models/Barcode.dart';
import 'package:scan_in/services/barcode_service.dart';
import 'package:scan_in/services/database_service.dart';
import 'package:barcode/barcode.dart';

class Barcodes extends StatefulWidget {
  @override
  _BarcodesState createState() => _BarcodesState();
}

class _BarcodesState extends State<Barcodes> {
  List<BarcodeEntity> _barcodesList = [];
  late BarcodeEntity _selectedBarcode;

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

  void _delete(int index) async {
    DatabaseService helper = DatabaseService.instance;
    bool deleted = await helper.deleteBarcodeByIndex(index);
    if (deleted) {
      print('barcode deleted');
      _loadBarcodes();
    } else {
      print('barcod not deleted');
    }
  }

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

    int iRows = await BarcodeService.addBarcode(barcodeScanRes);
    if (iRows > 0) {
      _loadBarcodes();
    }
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
                      _delete(_selectedBarcode.id);
                      Navigator.pop(context);
                    },
                    child: Text('Delete "' + _selectedBarcode.title + '"'),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.star_border_rounded, color: Colors.amber[600]),
                onPressed: () => _setFeaturedBarcode(_selectedBarcode.id),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setFeaturedBarcode(int bcId) async {
    await DatabaseService.instance.setFeaturedBarcode(bcId);
  }

  Widget BarcodeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _barcodesList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(_barcodesList[index].title),
          subtitle: Text(_barcodesList[index].data),
          leading:
              _barcodesList[index].featured ? Icon(Icons.star_rounded) : null,
          trailing: IconButton(
            icon: Icon(Icons.edit_rounded),
            onPressed: () {
              setState(() {
                _selectedBarcode = _barcodesList[index];
              });
              _openEditBarcodeModal();
            },
          ),
          onTap: () {
            setState(() {
              _selectedBarcode = _barcodesList[index];
            });
            _openViewBarcodeModal();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add AnimatedList to show barcode additions and removals
    return Scaffold(
      body: RefreshIndicator(
        child: _barcodesList.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('It\'s empty here. Try adding a new barcode.'),
              )
            : BarcodeList(),
        onRefresh: _loadBarcodes,
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
