import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import '../models/coleta_model.dart';
import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/models/midia_model.dart';

abstract class ColetaLocalDatasource {
  Future<List<ColetaModel>> getAll();
  Future<List<ColetaModel>> getPendentes();
  Future<ColetaModel?> getById(String uuid);
  Future<int> contarTodas();
  Future<int> contarPorStatus(StatusColeta status);
  Future<List<ColetaModel>> getRecentes(int limite);
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
    return _attachMidias(rows.map(ColetaModel.fromRow).toList());
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
    return _attachMidias(rows.map(ColetaModel.fromRow).toList());
  }

  @override
  Future<ColetaModel?> getById(String uuid) async {
    final row =
        await (_db.select(_db.coletas)
              ..where((t) => t.uuid.equals(uuid) & t.deletadoEm.isNull()))
            .getSingleOrNull();
    if (row == null) return null;
    final list = await _attachMidias([ColetaModel.fromRow(row)]);
    return list.first;
  }

  @override
  Future<int> contarTodas() async {
    final rows = await (_db.select(
      _db.coletas,
    )..where((t) => t.deletadoEm.isNull())).get();
    return rows.length;
  }

  @override
  Future<int> contarPorStatus(StatusColeta status) async {
    final rows =
        await (_db.select(_db.coletas)..where(
              (t) =>
                  t.statusSincronizacao.equalsValue(status) &
                  t.deletadoEm.isNull(),
            ))
            .get();
    return rows.length;
  }

  @override
  Future<List<ColetaModel>> getRecentes(int limite) async {
    final rows =
        await (_db.select(_db.coletas)
              ..where((t) => t.deletadoEm.isNull())
              ..orderBy([(t) => OrderingTerm.desc(t.dataColeta)])
              ..limit(limite))
            .get();
    return _attachMidias(rows.map(ColetaModel.fromRow).toList());
  }

  Future<List<ColetaModel>> _attachMidias(List<ColetaModel> coletas) async {
    if (coletas.isEmpty) return coletas;
    final ids = coletas.map((c) => c.id).toList();
    final midiasRows =
        await (_db.select(_db.midias)..where(
              (t) => t.mediableId.isIn(ids) & t.mediableType.equals('coleta'),
            ))
            .get();

    final midiasMap = <String, List<MidiaModel>>{};
    for (final row in midiasRows) {
      final midia = MidiaModel(
        id: row.id,
        mediableType: row.mediableType,
        mediableId: row.mediableId,
        storagePath: row.storagePath,
        mimeType: row.mimeType,
        tipo: row.tipo,
        url: row.url,
        descricao: row.descricao,
      );
      midiasMap.putIfAbsent(row.mediableId, () => []).add(midia);
    }

    return coletas.map((c) {
      return ColetaModel(
        id: c.id,
        usuarioId: c.usuarioId,
        dataColeta: c.dataColeta,
        syncStatus: c.syncStatus,
        nomeBem: c.nomeBem,
        localizacao: c.localizacao,
        artefatoTipos: c.artefatoTipos,
        versao: c.versao,
        updatedAt: c.updatedAt,
        dadosColetados: c.dadosColetados,
        midias: midiasMap[c.id] ?? [],
        natureza: c.natureza,
        tipo: c.tipo,
        uf: c.uf,
        deletadoEm: c.deletadoEm,
      );
    }).toList();
  }

  @override
  Future<void> inserir(ColetaModel coleta) async {
    await _db.transaction(() async {
      await _db.into(_db.coletas).insertOnConflictUpdate(coleta.toCompanion());

      // Delete existing midias for this collection
      await (_db.delete(
        _db.midias,
      )..where((t) => t.mediableId.equals(coleta.id))).go();

      // Insert new midias
      for (final midia in coleta.midias) {
        await _db
            .into(_db.midias)
            .insert(
              MidiasCompanion.insert(
                id: midia.id,
                mediableType: midia.mediableType,
                mediableId: midia.mediableId,
                storagePath: midia.storagePath,
                mimeType: midia.mimeType,
                tipo: midia.tipo,
                url: midia.url,
                descricao: Value(midia.descricao),
              ),
            );
      }
    });
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
