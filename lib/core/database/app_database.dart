import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
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
    Usuarios,
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
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();

    final dbDir = await getApplicationSupportDirectory();
    final dbPath = p.join(dbDir.path, 'sistema_arqueologico.db');

    final executor = NativeDatabase.createInBackground(
      File(dbPath),
      setup: (rawDb) {
        rawDb.execute("PRAGMA key = '$passphrase';");
        final result = rawDb.select('PRAGMA cipher_version;');
        log(
          'SQLCipher version: ${result.first.values.first}',
          name: 'AppDatabase',
        );
      },
    );

    return AppDatabase(executor);
  }
}
