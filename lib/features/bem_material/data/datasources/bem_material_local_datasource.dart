import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import '../models/bem_material_model.dart';

abstract class BemMaterialLocalDatasource {
  Future<List<BemMaterialModel>> getAll();
  Future<List<BemMaterialModel>> getByColetaId(String coletaId);
  Future<BemMaterialModel?> getById(String uuid);
  Future<void> inserir(BemMaterialModel bemMaterial);
  Future<void> deletar(String uuid);
}

class BemMaterialLocalDatasourceImpl implements BemMaterialLocalDatasource {
  final AppDatabase _db;

  const BemMaterialLocalDatasourceImpl(this._db);

  @override
  Future<List<BemMaterialModel>> getAll() async {
    final rows = await (_db.select(
      _db.bensMateriais,
    )..where((t) => t.deletadoEm.isNull())).get();
    return rows.map(BemMaterialModel.fromRow).toList();
  }

  @override
  Future<List<BemMaterialModel>> getByColetaId(String coletaId) async {
    final rows = await (_db.select(
      _db.bensMateriais,
    )..where((t) => t.coletaId.equals(coletaId) & t.deletadoEm.isNull())).get();
    return rows.map(BemMaterialModel.fromRow).toList();
  }

  @override
  Future<BemMaterialModel?> getById(String uuid) async {
    final row = await (_db.select(
      _db.bensMateriais,
    )..where((t) => t.uuid.equals(uuid))).getSingleOrNull();
    return row != null ? BemMaterialModel.fromRow(row) : null;
  }

  @override
  Future<void> inserir(BemMaterialModel bemMaterial) async {
    await _db
        .into(_db.bensMateriais)
        .insertOnConflictUpdate(bemMaterial.toCompanion());
  }

  @override
  Future<void> deletar(String uuid) async {
    await (_db.update(_db.bensMateriais)..where((t) => t.uuid.equals(uuid)))
        .write(BensMateriaisCompanion(deletadoEm: Value(DateTime.now())));
  }
}
