import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/artefato_tipo_model.dart';
import 'package:sistema_coleta_arqueologica/core/services/foto_upload_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/coleta_sync_strategy.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_repository.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/entities/sync_resumo.dart';
import '../../helpers/fakes/fake_sync_api_datasource.dart';

// ---------------------------------------------------------------------------
// Stubs internos
// ---------------------------------------------------------------------------

class _FakeColetaLocalDatasource implements ColetaLocalDatasource {
  _FakeColetaLocalDatasource({List<ColetaModel>? pendentes})
    : _pendentes = pendentes ?? [];

  final List<ColetaModel> _pendentes;
  final Map<String, StatusColeta> statusAtualizado = {};

  @override
  Future<List<ColetaModel>> getAll() async => _pendentes;

  @override
  Future<List<ColetaModel>> getPendentes() async => _pendentes;

  @override
  Future<ColetaModel?> getById(String uuid) async =>
      _pendentes.where((c) => c.id == uuid).firstOrNull;

  @override
  Future<int> contarTodas() async => _pendentes.length;

  @override
  Future<int> contarPorStatus(StatusColeta status) async =>
      _pendentes.where((c) => c.syncStatus == status).length;

  @override
  Future<List<ColetaModel>> getRecentes(int limite) async =>
      _pendentes.take(limite).toList();

  @override
  Future<void> inserir(ColetaModel coleta) async => _pendentes.add(coleta);

  @override
  Future<void> atualizarStatus(
    String uuid,
    StatusColeta status,
    int novaVersao,
  ) async => statusAtualizado[uuid] = status;

  @override
  Future<void> salvarFotosUrls(String uuid, List<String> urls) async {}

  @override
  Future<void> deletar(String uuid) async =>
      _pendentes.removeWhere((c) => c.id == uuid);
}

class _FakeFotoUploadService extends FotoUploadService {
  _FakeFotoUploadService() : super(Dio());

  @override
  Future<FotoUploadResult> uploadFotos({
    required List<String> localPaths,
    void Function(int current, int total)? onProgress,
  }) async => const FotoUploadResult(uploadedUrls: [], failedPaths: []);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaModel _criarColetaPendente(String id) => ColetaModel(
  id: id,
  usuarioId: 'usuario-1',
  nomeBem: 'Bem $id',
  localizacao: LocalizacaoModel(id: 'loc-$id', lat: -2.9078, lng: -41.7722),
  dataColeta: DateTime(2024),
  updatedAt: DateTime(2024),
  versao: 1,
  syncStatus: StatusColeta.pendente,
  artefatoTipos: const [ArtefatoTipoModel(id: 'tipo-ceramica', nome: 'ceramica')],
  dadosColetados: {},
);

SyncRepository _criarRepositorio({
  required _FakeColetaLocalDatasource datasource,
  SyncApiDatasource? apiDatasource,
}) => SyncRepository(
  coletaDatasource: datasource,
  strategy: ColetaSyncStrategy(
    apiDatasource: apiDatasource ?? FakeSyncApiDatasource(),
    fotoUploadService: _FakeFotoUploadService(),
  ),
);

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('SyncRepository.sincronizarTodas', () {
    test('nenhuma coleta pendente retorna resumo zerado', () async {
      final datasource = _FakeColetaLocalDatasource();
      final repo = _criarRepositorio(datasource: datasource);

      final resumo = await repo.sincronizarTodas();

      expect(resumo.total, 0);
      expect(resumo.totalOk, isTrue);
      expect(datasource.statusAtualizado, isEmpty);
    });

    test('sync bem-sucedido avança status para sincronizado', () async {
      final coleta = _criarColetaPendente('coleta-ok');
      final datasource = _FakeColetaLocalDatasource(pendentes: [coleta]);
      final repo = _criarRepositorio(
        datasource: datasource,
        apiDatasource: FakeSyncApiDatasource(status: SyncResultStatus.sucesso),
      );

      final resumo = await repo.sincronizarTodas();

      expect(resumo.sucessos, 1);
      expect(resumo.conflitos, 0);
      expect(resumo.erros, 0);
      expect(
        datasource.statusAtualizado['coleta-ok'],
        StatusColeta.sincronizado,
        reason:
            'Sync ≠ aprovação: status avança para sincronizado '
            '(dados transmitidos), não necessariamente aprovados pelo servidor',
      );
    });

    test('resposta 409 marca a coleta como conflito', () async {
      final coleta = _criarColetaPendente('coleta-conflito');
      final datasource = _FakeColetaLocalDatasource(pendentes: [coleta]);
      final repo = _criarRepositorio(
        datasource: datasource,
        apiDatasource: FakeSyncApiDatasource(status: SyncResultStatus.conflito),
      );

      final resumo = await repo.sincronizarTodas();

      expect(resumo.conflitos, 1);
      expect(resumo.sucessos, 0);
      expect(
        datasource.statusAtualizado['coleta-conflito'],
        StatusColeta.conflito,
      );
    });

    test('falha de rede mantém o status sem atualização', () async {
      final coleta = _criarColetaPendente('coleta-erro');
      final datasource = _FakeColetaLocalDatasource(pendentes: [coleta]);
      final repo = _criarRepositorio(
        datasource: datasource,
        apiDatasource: FakeSyncApiDatasource(status: SyncResultStatus.erroRede),
      );

      final resumo = await repo.sincronizarTodas();

      expect(resumo.erros, 1);
      expect(datasource.statusAtualizado.containsKey('coleta-erro'), isFalse);
    });

    test('múltiplas coletas são sincronizadas individualmente', () async {
      final coletas = [
        _criarColetaPendente('c1'),
        _criarColetaPendente('c2'),
        _criarColetaPendente('c3'),
      ];
      final datasource = _FakeColetaLocalDatasource(pendentes: coletas);
      final repo = _criarRepositorio(
        datasource: datasource,
        apiDatasource: FakeSyncApiDatasource(status: SyncResultStatus.sucesso),
      );

      final resumo = await repo.sincronizarTodas();

      expect(resumo.sucessos, 3);
      expect(datasource.statusAtualizado.length, 3);
      for (final id in ['c1', 'c2', 'c3']) {
        expect(datasource.statusAtualizado[id], StatusColeta.sincronizado);
      }
    });
  });

  group('SyncRepository.contarPendentes', () {
    test('retorna a contagem correta de coletas pendentes', () async {
      final datasource = _FakeColetaLocalDatasource(
        pendentes: [_criarColetaPendente('p1'), _criarColetaPendente('p2')],
      );
      final repo = _criarRepositorio(datasource: datasource);

      final total = await repo.contarPendentes();

      expect(total, 2);
    });
  });
}
