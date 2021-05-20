import 'package:path/path.dart';
import 'package:scan_in/models/Barcode.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final String _dbPath = "Barcodes.db";
  final String _dbTable = "barcodes";
  final int _dbVersion = 1;

  static final DatabaseService instance = new DatabaseService.internal();

  factory DatabaseService() => instance;
  static late Database _database;
  static bool _isDBInitialised = false;

  Future<Database> get database async {
    if (_isDBInitialised) {
      return _database;
    }
    _database = await initDB();
    _isDBInitialised = true;

    return _database;
  }

  DatabaseService.internal();

  initDB() async {
    String path = join(await getDatabasesPath(), _dbPath);
    _database =
        await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return _database;
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    // Get names of barcode id and data fields
    String bid = Barcode.idField;
    String bdf = Barcode.dataField;
    await db.execute('''
          CREATE TABLE $_dbTable (
            $bid INTEGER PRIMARY KEY,
            $bdf TEXT NOT NULL
          )
          ''');
  }

  // Database helper methods:

  Future<int> insert(Barcode bc) async {
    Database dbClient = await database;
    int id = await dbClient.insert(_dbTable, bc.toMap());
    return id;
  }

  Future<Barcode> queryBarcode(int id) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(_dbTable,
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
    int deletedRows = await db.rawDelete("DELETE FROM $_dbTable");
    return deletedRows;
  }

  Future<List<Barcode>> loadAll() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(_dbTable);
    List<Barcode> result = [];
    maps.forEach((map) {
      result.add(Barcode.fromMap(map));
    });
    return result;
  }

  Future<bool> deleteBarcodeByIndex(int index) async {
    Database db = await database;
    int deletedRows = await db.delete(
      _dbTable,
      where: Barcode.idField + ' = ?',
      whereArgs: [index],
    );
    return deletedRows > 0;
  }

  Future<int> getNextBarcodeId() async {
    Database db = await database;
    // Find the highest barcode id existing in the database
    List<Map<String, dynamic>> query =
        await db.query(_dbTable, orderBy: Barcode.idField + ' DESC', limit: 1);
    // Return the highest existing barcode id + 1
    // Next available barcode id

    // If there are no existing barcodes return the id for the initial barcode (1)
    if (query.isNotEmpty) {
      // Get most recent barcode's id and increment it by one
      return query[0]['_id'] + 1;
    } else {
      return 1;
    }
  }
}
