import 'dart:io';
import 'package:path/path.dart';
import 'package:scan_in/models/Barcode.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Database table and column names
final String tableBarcodes = 'barcodes';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "BarcodeDB.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  static late Database _database;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  //static Database _database;
  Future<Database> get database async {
    if (!_database.isOpen) {
      _database = await _initDatabase();
    }
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    String bid = Barcode.idField;
    String bdf = Barcode.dataField;
    await db.execute('''
          CREATE TABLE $tableBarcodes (
            $bid INTEGER PRIMARY KEY,
            $bdf TEXT NOT NULL
          )
          ''');
  }

  // Database helper methods:

  Future<int> insert(Barcode bc) async {
    Database db = await database;
    int id = await db.insert(tableBarcodes, bc.toMap());
    return id;
  }

  Future<Barcode> queryBarcode(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableBarcodes,
        columns: [Barcode.idField, Barcode.dataField],
        where: Barcode.idField + ' = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Barcode.fromMap(maps.first);
    } else {
      throw Exception('you are gay');
    }
  }

  Future<int> clearDatabase() async {
    Database db = await database;
    int deletedRows = await db.rawDelete("DELETE FROM $tableBarcodes");
    return deletedRows;
  }

  Future<List<Barcode>> loadAll() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableBarcodes);
    List<Barcode> result = [];
    maps.forEach((map) {
      result.add(Barcode.fromMap(map));
    });
    return result;
  }

  Future<bool> deleteBarcodeByIndex(int index) async {
    Database db = await database;
    int deletedRows = await db.delete(
      tableBarcodes,
      where: Barcode.idField + ' = ?',
      whereArgs: [index],
    );
    return deletedRows > 0;
  }

  Future<int> getNextBarcodeId() async {
    Database db = await database;
    // Find the highest barcode id existing in the database
    List<Map<String, dynamic>> query = await db.query(tableBarcodes,
        orderBy: Barcode.idField + ' DESC', limit: 1);
    // Return the highest existing barcode id + 1
    // Next available barcode id
    return query[0]['_id'] + 1;
  }
}
