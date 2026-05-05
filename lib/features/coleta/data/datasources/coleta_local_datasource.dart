import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import '../models/coleta_model.dart';
import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

abstract class ColetaLocalDatasource {
  Future<List<ColetaModel>> getAll();
  Future<List<ColetaModel>> getPendentes();
  Future<ColetaModel?> getById(String uuid);
  Future<void> inserir(ColetaModel coleta);
  Future<void> atualizarStatus(
    String uuid,
    StatusColeta status,
    int novaVersao,
  );
  Future<void> deletar(String uuid);
}

class ColetaLocalDatasourceImpl implements ColetaLocalDatasource {
  final AppDatabase _db;

  const ColetaLocalDatasourceImpl(this._db);

  @override
  Future<List<ColetaModel>> getAll() async {
    final rows = await (_db.select(
      _db.coletas,
    )..where((t) => t.deletadoEm.isNull())).get();
    return rows.map(ColetaModel.fromRow).toList();
  }

  @override
  Future<List<ColetaModel>> getPendentes() async {
    final rows =
        await (_db.select(_db.coletas)..where(
              (t) =>
                  t.statusSincronizacao.equalsValue(StatusColeta.pendente) &
                  t.deletadoEm.isNull(),
            ))
            .get();
    return rows.map(ColetaModel.fromRow).toList();
  }

  @override
  Future<ColetaModel?> getById(String uuid) async {
    final row = await (_db.select(
      _db.coletas,
    )..where((t) => t.uuid.equals(uuid))).getSingleOrNull();
    return row != null ? ColetaModel.fromRow(row) : null;
  }

  @override
  Future<void> inserir(ColetaModel coleta) async {
    await _db.into(_db.coletas).insertOnConflictUpdate(coleta.toCompanion());
  }

  @override
  Future<void> atualizarStatus(
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
  Future<void> deletar(String uuid) async {
    await (_db.update(_db.coletas)..where((t) => t.uuid.equals(uuid))).write(
      ColetasCompanion(deletadoEm: Value(DateTime.now())),
    );
  }
}
