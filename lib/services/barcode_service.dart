import 'package:scan_in/models/Barcode.dart';
import 'package:scan_in/services/database_service.dart';

class BarcodeService {
  static Future<int> addBarcode(String data) async {
    // Get the next available barcode id
    int id = await DatabaseHelper.instance.getNextBarcodeId();
    // Insert the new barcode into the local database
    return await DatabaseHelper.instance.insert(
        Barcode.fromMap({Barcode.idField: id, Barcode.dataField: data}));
  }
}
