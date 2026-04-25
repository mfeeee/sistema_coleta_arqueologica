import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'converters/json_map_converters.dart';

import 'tables/usuarios_table.dart';
import 'tables/coletas_table.dart';
import 'tables/bens_materiais_table.dart';
import 'tables/curadorias_table.dart';
import 'tables/midia_links_table.dart';
import 'tables/responsaveis_sitio_table.dart';
import 'tables/auditorias_table.dart';

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
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'sistema_arqueologico',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
