import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import '../models/bem_material_cache_model.dart';
import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/enum_converters.dart';

abstract class BemMaterialLocalDatasource {
  Future<List<BemMaterialCacheModel>> getAllBensMateriaisCache();
  Future<void> insertBemMaterial(BemMaterialCacheModel bemMaterial);
  Future<void> updateSyncStatus(
    String uuid,
    StatusColeta status,
    int novaVersao,
  );
}

class BemMaterialLocalDatasourceImpl implements BemMaterialLocalDatasource {
  final AppDatabase _db;

  const BemMaterialLocalDatasourceImpl(this._db);

  @override
  Future<List<BemMaterialCacheModel>> getAllBensMateriaisCache() async {
    final rows = await _db.select(_db.coletas).get();
    return rows.map(BemMaterialCacheModel.fromColetaData).toList();
  }

  @override
  Future<void> insertBemMaterial(BemMaterialCacheModel bemMaterial) async {
    await _db
        .into(_db.coletas)
        .insertOnConflictUpdate(bemMaterial.toCompanion());
  }

  @override
  Future<void> updateSyncStatus(
    String uuid,
    StatusColeta status,
    int novaVersao,
  ) async {
    await (_db.update(_db.coletas)..where((t) => t.uuid.equals(uuid))).write(
      ColetasCompanion(
        statusSincronizacao: Value(status),
        versao: Value(novaVersao),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
