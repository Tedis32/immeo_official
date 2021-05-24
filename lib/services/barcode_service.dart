import 'package:scan_in/entities/BarcodeEntity.dart';
import 'package:scan_in/services/database_service.dart';

class BarcodeService {
  static Future<BarcodeEntity> addBarcode(String data) async {
    // TODO: Allow duplicate barcode data's or not
    // Get the next available barcode id
    int id = await DatabaseService.instance.getNextBarcodeId();
    // Insert the new barcode into the local database
    return await DatabaseService.instance.insert(BarcodeEntity.fromMap(
        {BarcodeEntity.idField: id, BarcodeEntity.dataField: data}));
  }

  static Future<int> setFeatured(int id) async {
    DatabaseService.instance.setFeaturedBarcode(id);
    return 1;
  }
}
