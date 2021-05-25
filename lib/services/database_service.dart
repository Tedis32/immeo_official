import 'package:path/path.dart';
import 'package:scan_in/entities/BarcodeEntity.dart';
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
    String bid = BarcodeEntity.idField;
    String bdf = BarcodeEntity.dataField;
    String tdf = BarcodeEntity.titleField;
    String fdf = BarcodeEntity.featuredField;
    await db.execute('''
          CREATE TABLE $_dbTable (
            $bid INTEGER PRIMARY KEY,
            $bdf TEXT NOT NULL,
            $tdf TEXT NOT NULL,
            $fdf INTEGER NOT NULL
          )
          ''');
  }

  // Database helper methods:

  Future<BarcodeEntity> insert(BarcodeEntity bc) async {
    Database dbClient = await database;
    await dbClient.insert(_dbTable, bc.toMap());
    return bc;
  }

  Future<BarcodeEntity> queryBarcode(int id) async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query(_dbTable,
        columns: [BarcodeEntity.idField, BarcodeEntity.dataField],
        where: '${BarcodeEntity.idField} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return BarcodeEntity.fromMap(maps.first);
    } else {
      throw Exception('you are gay');
    }
  }

  Future<int> clearDatabase() async {
    Database db = await database;
    int deletedRows = await db.rawDelete("DELETE FROM $_dbTable");
    print('Deleted: $deletedRows entried from the database');
    return deletedRows;
  }

  Future<List<BarcodeEntity>> loadAll() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(_dbTable);
    List<BarcodeEntity> result = [];
    maps.forEach((map) {
      result.add(BarcodeEntity.fromMap(map));
    });
    return result;
  }

  Future<bool> deleteBarcodeById(int id) async {
    Database db = await database;
    int deletedRows = await db.delete(
      _dbTable,
      where: '${BarcodeEntity.idField} = ?',
      whereArgs: [id],
    );
    return deletedRows > 0;
  }

  Future<int> getNextBarcodeId() async {
    Database db = await database;
    // Find the highest barcode id existing in the database
    List<Map<String, dynamic>> query = await db.query(_dbTable,
        orderBy: BarcodeEntity.idField + ' DESC', limit: 1);
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

  Future<int> updateBarcodeById(int id, Map<String, dynamic> data) async {
    Database dbClient = await database;
    int changesMade = await dbClient.update(
      _dbTable,
      data,
      where: BarcodeEntity.idField + ' = ?',
      whereArgs: [id],
    );
    return changesMade;
  }

  Future setFeaturedBarcode(int id) async {
    Database dbClient = await database;
    List<Map<String, dynamic>> barcodes = await dbClient.query(_dbTable,
        columns: [BarcodeEntity.idField],
        where: BarcodeEntity.featuredField + ' = ?',
        whereArgs: [1]);

    if (barcodes.isNotEmpty) {
      await updateBarcodeById(barcodes.first[BarcodeEntity.idField],
          {BarcodeEntity.featuredField: 0});
    }

    // Set the barcode as featured if it was not the previously featured barcode
    if (barcodes.isEmpty || barcodes.first[BarcodeEntity.idField] != id) {
      await updateBarcodeById(id, {BarcodeEntity.featuredField: 1});
    }
  }

  Future<BarcodeEntity> getFeaturedBarcode() async {
    Database dbClient = await database;
    List<Map<String, dynamic>> barcodes = await dbClient.query(_dbTable,
        where: BarcodeEntity.featuredField + ' = ?', whereArgs: [1], limit: 1);

    if (barcodes.isNotEmpty) {
      return BarcodeEntity.fromMap(barcodes.first);
    }
    throw Exception('No featured barcode found');
  }
}
