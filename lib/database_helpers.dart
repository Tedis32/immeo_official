import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Database table and column names
final String tableBarcodes = 'barcodes';
final String columnId = '_id';
final String columnBarcode = 'barcode';

// Data model class
class Barcode {
  int id;
  String data;

  Barcode();

  // convenience constructor to create a Word object
  Barcode.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    data = map[columnBarcode];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBarcode: data,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "BarcodeDB.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
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
    await db.execute('''
          CREATE TABLE $tableBarcodes (
            $columnId INTEGER PRIMARY KEY,
            $columnBarcode TEXT NOT NULL
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
    List<Map> maps = await db.query(tableBarcodes,
        columns: [columnId, columnBarcode],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Barcode.fromMap(maps.first);
    }
    return null;
  }

  Future<int> clearDatabase() async {
    Database db = await database;
    int deletedRows = await db.rawDelete("DELETE FROM $tableBarcodes");
    return deletedRows;
  }

  // TODO: queryAllWords()
  // TODO: delete(int id)
  // TODO: update(Word word)
}
