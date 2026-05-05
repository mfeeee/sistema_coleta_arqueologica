import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import '../models/coleta_model.dart';
import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

abstract class ColetaLocalDatasource {
  Future<List<ColetaModel>> getAllBensMateriaisCache();
  Future<void> insertBemMaterial(ColetaModel bemMaterial);
  Future<void> updatecoletaStatus(
    String uuid,
    StatusColeta status,
    int novaVersao,
  );
  Future<List<ColetaModel>> getBensPendentes();
}

class ColetaLocalDatasourceImpl implements ColetaLocalDatasource {
  final AppDatabase _db;

  const ColetaLocalDatasourceImpl(this._db);

  @override
  Future<List<ColetaModel>> getAllBensMateriaisCache() async {
    final rows = await _db.select(_db.coletas).get();
    return rows.map(ColetaModel.fromColetaData).toList();
  }

  @override
  Future<void> insertBemMaterial(ColetaModel bemMaterial) async {
    await _db
        .into(_db.coletas)
        .insertOnConflictUpdate(bemMaterial.toCompanion());
  }

  @override
  Future<void> updatecoletaStatus(
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

  @override
  Future<List<ColetaModel>> getBensPendentes() async {
    final rows =
        await (_db.select(_db.coletas)..where(
              (t) => t.statusSincronizacao.equalsValue(StatusColeta.pendente),
            ))
            .get();
    return rows.map(ColetaModel.fromColetaData).toList();
  }
}
