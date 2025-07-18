import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<void> insert(NotificationModel model);
  Future<List<NotificationModel>> fetchAll();
  Future<void> updateStatus(String id, bool isAccepted);
  Future<void> delete(String id);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static final NotificationLocalDataSourceImpl instance =
      NotificationLocalDataSourceImpl._init();
  static Database? _database;
  NotificationLocalDataSourceImpl._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT,
        body TEXT,
        userId TEXT,
        amount REAL,
        cardNumber TEXT,
        isAccepted INTEGER
      )
    ''');
  }

  @override
  Future<void> insert(NotificationModel model) async {
    final db = await database;
    await db.insert(
      'notifications',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<NotificationModel>> fetchAll() async {
    final db = await database;
    final maps = await db.query('notifications');
    return maps.map((map) => NotificationModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateStatus(String id, bool isAccepted) async {
    final db = await database;
    await db.update(
      'notifications',
      {'isAccepted': isAccepted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }
}
