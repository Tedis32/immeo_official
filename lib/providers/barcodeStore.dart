import 'package:flutter/foundation.dart';
import 'package:scan_in/entities/BarcodeEntity.dart';
import 'package:scan_in/services/database_service.dart';

class BarcodeStore with ChangeNotifier {
  BarcodeStore() {
    this.refreshBarcodes();
  }

  List<BarcodeEntity> _barcodes = [];
  List<BarcodeEntity> get barcodes => _barcodes;
  BarcodeEntity get featured => barcodes[featuredIndex];

  bool hasFeatured = false;
  int featuredIndex = -1;

  void addBarcode(BarcodeEntity barcode) async {
    _barcodes.add(barcode);
    notifyListeners();
  }

  Future refreshBarcodes() async {
    print('Refreshing _barcodes');
    _barcodes.clear();

    List<BarcodeEntity> bcs = await DatabaseService.instance.loadAll();
    for (int i = 0; i < bcs.length; i++) {
      if (bcs[i].featured == 1) {
        featuredIndex = i;
        hasFeatured = true;
      }
      _barcodes.add(bcs[i]);
    }
    notifyListeners();
  }

  Future removeBarcode(int id) async {
    await DatabaseService.instance.deleteBarcodeById(id);
    for (int i = 0; i < _barcodes.length; i++) {
      if (_barcodes[i].id == id) {
        if (i == featuredIndex) {
          featuredIndex = -1;
          hasFeatured = false;
        }
        _barcodes.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  Future setFeaturedBarcode(int id) async {
    print('Setting featured barcode: $id');
    await DatabaseService.instance.setFeaturedBarcode(id);

    refreshBarcodes();
  }
}
