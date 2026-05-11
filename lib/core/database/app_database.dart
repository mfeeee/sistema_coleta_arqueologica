import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'converters/json_map_converter.dart';

import 'tables/usuarios_table.dart';
import 'tables/coletas_table.dart';
import 'tables/bens_materiais_table.dart';
import 'tables/curadorias_table.dart';
import 'tables/midia_links_table.dart';
import 'tables/responsaveis_sitio_table.dart';
import 'tables/auditorias_table.dart';

import 'enums/perfil_usuario.dart';
import 'enums/status_coleta.dart';
import 'enums/status_curadoria.dart';
import 'enums/tipo_midia.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Coletas,
    BensMateriais,
    Curadorias,
    MidiaLinks,
    ResponsaveisSitio,
    Auditorias,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static Future<AppDatabase> open(String passphrase) async {
    final dbDir = await getApplicationSupportDirectory();
    final dbPath = p.join(dbDir.path, 'sistema_arqueologico.db');
    final dbFile = File(dbPath);

    return _abrirComFallback(dbFile, passphrase);
  }

  static AppDatabase _criar(File dbFile, String passphrase) {
    final executor = NativeDatabase(
      dbFile,
      setup: (rawDb) {
        rawDb.execute("PRAGMA key = '$passphrase';");
        rawDb.select('SELECT count(*) FROM sqlite_master;');
      },
    );
    return AppDatabase(executor);
  }

  static Future<AppDatabase> _abrirComFallback(
    File dbFile,
    String passphrase,
  ) async {
    final db = _criar(dbFile, passphrase);
    try {
      await db.customSelect('SELECT 1').get();
      return db;
    } catch (e) {
      await db.close();
      if (await dbFile.exists()) await dbFile.delete();
      return _criar(dbFile, passphrase);
    }
  }
}
