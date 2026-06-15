// test/features/coleta/data/coleta_local_datasource_integration_test.dart
import 'package:checks/checks.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/models/artefato_tipo_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';

// Banco Drift 100% em memória — sem arquivo, sem SQLCipher
AppDatabase _criarBancoMemoria() =>
    AppDatabase(NativeDatabase.memory());

ColetaModel _criarColeta(String id, {StatusColeta status = StatusColeta.pendente}) =>
    ColetaModel(
      id: id,
      usuarioId: 'arq-001',
      nomeBem: 'Bem $id',
      localizacao: LocalizacaoModel(id: 'loc-$id', lat: -2.9078, lng: -41.7722),
      dataColeta: DateTime(2025, 1, 15),
      updatedAt: DateTime(2025, 1, 15),
      versao: 1,
      syncStatus: status,
      artefatoTipos: const [ArtefatoTipoModel(id: 'tipo-1', nome: 'Cerâmica')],
      dadosColetados: const {'nomes_populares': []},
    );

void main() {
  late AppDatabase db;
  late ColetaLocalDatasource datasource;

  setUp(() {
    db = _criarBancoMemoria();
    datasource = ColetaLocalDatasourceImpl(db);
  });

  tearDown(() => db.close());

  group('ColetaLocalDatasource — integração com banco real', () {
    test('inserir e recuperar por ID', () async {
      final coleta = _criarColeta('uuid-001');
      await datasource.inserir(coleta);

      final encontrada = await datasource.getById('uuid-001');

      check(encontrada).isNotNull();
      check(encontrada!.id).equals('uuid-001');
      check(encontrada.nomeBem).equals('Bem uuid-001');
      check(encontrada.syncStatus).equals(StatusColeta.pendente);
    });

    test('getAll retorna todas as coletas inseridas', () async {
      await datasource.inserir(_criarColeta('c1'));
      await datasource.inserir(_criarColeta('c2'));
      await datasource.inserir(_criarColeta('c3'));

      final todas = await datasource.getAll();

      check(todas).has((l) => l.length, 'length').equals(3);
    });

    test('getPendentes retorna apenas coletas com status pendente', () async {
      await datasource.inserir(_criarColeta('pend-1', status: StatusColeta.pendente));
      await datasource.inserir(_criarColeta('sync-1', status: StatusColeta.sincronizado));
      await datasource.inserir(_criarColeta('pend-2', status: StatusColeta.pendente));

      final pendentes = await datasource.getPendentes();

      check(pendentes.map((c) => c.id))
          ..contains('pend-1')
          ..contains('pend-2')
          ..not((it) => it.contains('sync-1'));
    });

    test('atualizarStatus muda o status corretamente no banco', () async {
      await datasource.inserir(_criarColeta('upd-001'));

      await datasource.atualizarStatus('upd-001', StatusColeta.sincronizado, 2);

      final atualizada = await datasource.getById('upd-001');
      check(atualizada!.syncStatus).equals(StatusColeta.sincronizado);
    });

    test('deletar remove a coleta do banco', () async {
      await datasource.inserir(_criarColeta('del-001'));
      await datasource.deletar('del-001');

      final resultado = await datasource.getById('del-001');
      check(resultado).isNull();
    });

    test('contarPorStatus conta corretamente', () async {
      await datasource.inserir(_criarColeta('p1', status: StatusColeta.pendente));
      await datasource.inserir(_criarColeta('p2', status: StatusColeta.pendente));
      await datasource.inserir(_criarColeta('s1', status: StatusColeta.sincronizado));

      final totalPendentes = await datasource.contarPorStatus(StatusColeta.pendente);
      check(totalPendentes).equals(2);
    });

    test('getRecentes retorna no máximo o limite solicitado', () async {
      for (var i = 1; i <= 5; i++) {
        await datasource.inserir(_criarColeta('r$i'));
      }

      final recentes = await datasource.getRecentes(3);
      check(recentes).has((l) => l.length, 'length').isLessOrEqual(3);
    });
   group('Persistence details', () {
    test('localizacao_completa is preserved in dadosColetados', () async {
      final coleta = _criarColeta('c-geo');
      await datasource.inserir(coleta);

      final recuperada = await datasource.getById('c-geo');
      check(recuperada!.dadosColetados).containsKey('localizacao_completa');
    });
  });
  });
}
