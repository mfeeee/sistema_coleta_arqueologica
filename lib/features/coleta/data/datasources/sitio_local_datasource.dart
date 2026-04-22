import '../models/sitio_cache_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class SitioLocalDatasource {
  Future<List<SitioCacheModel>> getAllSitiosCache();
  Future<void> insertSitio(SitioCacheModel sitio);
}

/// TODO: Implementar a conexão real com o Isar, SQLite ou Hive aqui.
class SitioLocalDatasourceImpl implements SitioLocalDatasource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('arqueologia_offline.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sitios_cache (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL
      )
    ''');
  }

  @override
  Future<List<SitioCacheModel>> getAllSitiosCache() async {
    final db = await database;

    final result = await db.query('sitios_cache');

    return result.map((map) => SitioCacheModel.fromMap(map)).toList();
  }

  @override
  Future<void> insertSitio(SitioCacheModel sitio) async {
    final db = await database;

    await db.insert(
      'sitios_cache',
      sitio.toMap(),
      conflictAlgorithm: ConflictAlgorithm
          .replace, // se o UUID já existir, ele atualiza os dados.
    );
  }
}
