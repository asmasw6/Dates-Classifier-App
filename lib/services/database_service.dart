import 'package:dates_classifier/models/history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseService {
  static Database? db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String historyTable = 'history';
  final String idColumnName = "id";
  final String predictionColumnName = "prediction";
  final String confidenceColumnName = "confidence";
  final String dateColumnName = "date";
  final String imageColumnName = "image";
  DatabaseService._constructor();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await getDatabase();
    return db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $historyTable(
          $idColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
          $predictionColumnName TEXT NOT NULL,
          $confidenceColumnName TEXT NOT NULL,
          $dateColumnName TEXT NOT NULL,
          $imageColumnName TEXT NOT NULL

        )
        
        ''');
      },
    );
    return database;
  }


  Future<int> insertHistory({
    required String prediction,
    required String confidence,
    required String date,
    required String imagePath,
  }) async {
    final db = await database;
    return await db.insert(historyTable, {
      predictionColumnName: prediction,
      confidenceColumnName: confidence,
      dateColumnName: date,
      imageColumnName: imagePath,
    });
  }

  /// Get all history records
  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query(historyTable, orderBy: "$idColumnName DESC");
  }

  /// Delete history by id
  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete(
      historyTable,
      where: "$idColumnName = ?",
      whereArgs: [id],
    );
  }

  Future<List<History>> getHistories() async {
    final db = await database;
    final data = await db.query(historyTable);
    //print(data);
    List<History> histories = data.map(
      (e) {
        return History(
            id: e['id'] as int?, // safe cast, can be null if no
            prediction: e['prediction'] as String,
            confidence: e['confidence'] as String,
            date: e['date'] as String,
            image: e['image'] as String); // Image.file(File(history.image))

      },
    ).toList();

    return histories;
  }
}
