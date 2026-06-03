import 'package:checks/checks.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/services/foto_upload_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/coleta_sync_strategy.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/entities/sync_resumo.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeSyncApiDatasource implements SyncApiDatasource {
  _FakeSyncApiDatasource({this.status = SyncResultStatus.sucesso});

  final SyncResultStatus status;

  @override
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    required String bearerToken,
    Map<String, dynamic>? dadosColetadosOverride,
    void Function(int tentativa, int max)? onTentativa,
  }) async => SyncResultado(coletaId: coleta.id, status: status);
}

class _SpyFotoUploadService extends FotoUploadService {
  _SpyFotoUploadService({List<String> uploadedUrls = const []})
    : _uploadedUrls = uploadedUrls,
      super(Dio());

  final List<String> _uploadedUrls;
  bool chamouUpload = false;

  @override
  Future<FotoUploadResult> uploadFotos({
    required List<String> localPaths,
    required String token,
    void Function(int current, int total)? onProgress,
  }) async {
    chamouUpload = true;
    return FotoUploadResult(uploadedUrls: _uploadedUrls, failedPaths: []);
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaEntity _criarColeta({Map<String, dynamic>? dadosColetados}) =>
    ColetaEntity(
      id: 'coleta-1',
      usuarioId: 'usuario-1',
      nomeBem: 'Sítio X',
      dataColeta: DateTime(2024),
      updatedAt: DateTime(2024),
      versao: 1,
      syncStatus: StatusColeta.pendente,
      artefatos: const [ArtefatoBem.ceramica],
      natureza: NaturezaBem.bemArqueologico,
      tipo: TipoBem.sitio,
      latitude: -2.9,
      longitude: -41.7,
      dadosColetados: dadosColetados ?? {},
    );

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('ColetaSyncStrategy.sincronizar', () {
    test('retorna SyncResultStatus.sucesso em caso feliz', () async {
      // Arrange
      final strategy = ColetaSyncStrategy(
        apiDatasource: _FakeSyncApiDatasource(),
        fotoUploadService: _SpyFotoUploadService(),
      );
      final coleta = _criarColeta();

      // Act
      final resultado = await strategy.sincronizar(coleta, 'token-fake');

      // Assert
      check(resultado.status).equals(SyncResultStatus.sucesso);
    });

    test('chama uploadFotos quando foto_paths não está vazio', () async {
      // Arrange
      final spy = _SpyFotoUploadService(
        uploadedUrls: ['https://cdn.example.com/foto.jpg'],
      );
      final strategy = ColetaSyncStrategy(
        apiDatasource: _FakeSyncApiDatasource(),
        fotoUploadService: spy,
      );
      final coleta = _criarColeta(
        dadosColetados: {
          'foto_paths': ['/tmp/foto.jpg'],
        },
      );

      // Act
      await strategy.sincronizar(coleta, 'token-fake');

      // Assert
      check(spy.chamouUpload).isTrue();
    });

    test('não chama uploadFotos quando foto_paths está vazio', () async {
      // Arrange
      final spy = _SpyFotoUploadService();
      final strategy = ColetaSyncStrategy(
        apiDatasource: _FakeSyncApiDatasource(),
        fotoUploadService: spy,
      );
      final coleta = _criarColeta(dadosColetados: {'foto_paths': <String>[]});

      // Act
      await strategy.sincronizar(coleta, 'token-fake');

      // Assert
      check(spy.chamouUpload).isFalse();
    });

    test(
      'não chama uploadFotos quando dadosColetados não tem foto_paths',
      () async {
        // Arrange
        final spy = _SpyFotoUploadService();
        final strategy = ColetaSyncStrategy(
          apiDatasource: _FakeSyncApiDatasource(),
          fotoUploadService: spy,
        );
        final coleta = _criarColeta();

        // Act
        await strategy.sincronizar(coleta, 'token-fake');

        // Assert
        check(spy.chamouUpload).isFalse();
      },
    );

    test(
      'uploadedUrls é populado com as URLs retornadas pelo upload',
      () async {
        // Arrange
        final urls = [
          'https://cdn.example.com/a.jpg',
          'https://cdn.example.com/b.jpg',
        ];
        final strategy = ColetaSyncStrategy(
          apiDatasource: _FakeSyncApiDatasource(),
          fotoUploadService: _SpyFotoUploadService(uploadedUrls: urls),
        );
        final coleta = _criarColeta(
          dadosColetados: {
            'foto_paths': ['/tmp/a.jpg', '/tmp/b.jpg'],
          },
        );

        // Act
        final resultado = await strategy.sincronizar(coleta, 'token-fake');

        // Assert
        check(resultado.uploadedUrls).deepEquals(urls);
      },
    );

    test('retorna SyncResultStatus.conflito quando API retorna 409', () async {
      // Arrange
      final strategy = ColetaSyncStrategy(
        apiDatasource: _FakeSyncApiDatasource(
          status: SyncResultStatus.conflito,
        ),
        fotoUploadService: _SpyFotoUploadService(),
      );

      // Act
      final resultado = await strategy.sincronizar(
        _criarColeta(),
        'token-fake',
      );

      // Assert
      check(resultado.status).equals(SyncResultStatus.conflito);
    });
  });
}
