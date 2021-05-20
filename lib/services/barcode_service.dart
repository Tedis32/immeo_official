import 'package:scan_in/models/Barcode.dart';
import 'package:scan_in/services/database_service.dart';

class BarcodeService {
  static Future<int> addBarcode(String data) async {
    // TODO: Allow duplicate barcode data's or not
    // Get the next available barcode id
    int id = await DatabaseService.instance.getNextBarcodeId();
    // Insert the new barcode into the local database
    return await DatabaseService.instance.insert(
        Barcode.fromMap({Barcode.idField: id, Barcode.dataField: data}));
  }
}
