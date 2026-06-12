import 'package:checks/checks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/features/auth/domain/usecases/executar_sync_pos_login_use_case.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_remota_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/obter_coletas_pendentes_use_case.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeSecureStorageService extends SecureStorageService {
  _FakeSecureStorageService() : super(const FlutterSecureStorage());

  @override
  Future<String?> getJwt() async => null;
}

class _FakeColetaRepository implements ColetaRepository {
  @override
  Future<List<ColetaEntity>> getAll() async => [];
  @override
  Future<List<ColetaEntity>> getPendentes() async => [];
  @override
  Future<ColetaEntity?> getById(String uuid) async => null;
  @override
  Future<int> contarTodas() async => 0;
  @override
  Future<int> contarPorStatus(dynamic status) async => 0;
  @override
  Future<List<ColetaEntity>> getRecentes(int limite) async => [];
  @override
  Future<void> salvar(ColetaEntity coleta) async {}
  @override
  Future<void> atualizarStatus(String uuid, dynamic status, int v) async {}
  @override
  Future<void> deletar(String uuid) async {}
}

class _FakeColetaRemotaRepository implements ColetaRemotaRepository {
  @override
  Future<ColetaPage> fetchMinhas({required int page}) async =>
      (items: <ColetaEntity>[], total: 0, temProxima: false);
}

class _SpyPullService extends PullService {
  _SpyPullService({bool throws = false})
    : _throws = throws,
      super(
        apiDatasource: _FakeColetaRemotaRepository(),
        localRepository: _FakeColetaRepository(),
        secureStorage: _FakeSecureStorageService(),
      );

  final bool _throws;
  bool chamouSincronizarPull = false;

  @override
  Future<int> sincronizarPull(String usuarioId) async {
    chamouSincronizarPull = true;
    if (_throws) throw Exception('falha de rede simulada');
    return 0;
  }
}

class _SpyBemMaterialRepository implements BemMaterialRepository {
  bool chamouSincronizarBens = false;

  @override
  Future<int> sincronizarBens({bool forcar = false}) async {
    chamouSincronizarBens = true;
    return 0;
  }

  @override
  Future<List<BemMaterialEntity>> getAll() async => [];
  @override
  Future<List<BemMaterialEntity>> getByColetaId(String id) async => [];
  @override
  Future<BemMaterialEntity?> getById(String uuid) async => null;
  @override
  Future<void> salvar(BemMaterialEntity bem) async {}
  @override
  Future<void> deletar(String uuid) async {}
}

class _FakeObterPendentes extends ObterColetasPendentesUseCase {
  _FakeObterPendentes({List<ColetaEntity>? retorno})
    : _retorno = retorno ?? [],
      super(_FakeColetaRepository());

  final List<ColetaEntity> _retorno;

  @override
  Future<List<ColetaEntity>> call() async => _retorno;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaEntity _coletaPendente() => ColetaEntity(
  id: 'coleta-1',
  usuarioId: 'u1',
  dataColeta: DateTime(2024),
  syncStatus: StatusColeta.pendente,
  nomeBem: 'Sítio X',
  artefatoTipos: const [],
  versao: 1,
  updatedAt: DateTime(2024),
  dadosColetados: const {},
);

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('ExecutarSyncPosLoginUseCase.call', () {
    test('executa pull pós-login com o usuarioId correto', () async {
      // Arrange
      final spyPull = _SpyPullService();
      final useCase = ExecutarSyncPosLoginUseCase(
        pullService: spyPull,
        bemMaterialRepository: _SpyBemMaterialRepository(),
        obterColetasPendentesUseCase: _FakeObterPendentes(),
        agendarSync: () async {},
      );

      // Act
      await useCase.call('usuario-1');
      await Future<void>.delayed(Duration.zero);

      // Assert
      check(spyPull.chamouSincronizarPull).isTrue();
    });

    test('executa sync de bens pós-login', () async {
      // Arrange
      final spyBens = _SpyBemMaterialRepository();
      final useCase = ExecutarSyncPosLoginUseCase(
        pullService: _SpyPullService(),
        bemMaterialRepository: spyBens,
        obterColetasPendentesUseCase: _FakeObterPendentes(),
        agendarSync: () async {},
      );

      // Act
      await useCase.call('usuario-1');
      await Future<void>.delayed(Duration.zero);

      // Assert
      check(spyBens.chamouSincronizarBens).isTrue();
    });

    test('chama agendarSync quando há coletas pendentes', () async {
      // Arrange — agendarSync só é invocado via _pushPendentes se pendentes > 0
      final chamouAgendar = <bool>[];
      final useCase = ExecutarSyncPosLoginUseCase(
        pullService: _SpyPullService(),
        bemMaterialRepository: _SpyBemMaterialRepository(),
        obterColetasPendentesUseCase: _FakeObterPendentes(
          retorno: [_coletaPendente()],
        ),
        agendarSync: () async => chamouAgendar.add(true),
      );

      // Act
      await useCase.call('usuario-1');
      await Future<void>.delayed(Duration.zero);

      // Assert
      check(chamouAgendar).isNotEmpty();
    });

    test('captura erro de pull sem lançar exceção para o chamador', () async {
      // Arrange
      final useCase = ExecutarSyncPosLoginUseCase(
        pullService: _SpyPullService(throws: true),
        bemMaterialRepository: _SpyBemMaterialRepository(),
        obterColetasPendentesUseCase: _FakeObterPendentes(),
        agendarSync: () async {},
      );

      // Act & Assert — call() não deve propagar o erro do pull
      await check(useCase.call('usuario-1')).completes();
      await Future<void>.delayed(Duration.zero);
    });

    test('invoca onAviso quando pull falha', () async {
      // Arrange
      final avisos = <String>[];
      final useCase = ExecutarSyncPosLoginUseCase(
        pullService: _SpyPullService(throws: true),
        bemMaterialRepository: _SpyBemMaterialRepository(),
        obterColetasPendentesUseCase: _FakeObterPendentes(),
        agendarSync: () async {},
        onAviso: avisos.add,
      );

      // Act
      await useCase.call('usuario-1');
      await Future<void>.delayed(Duration.zero);

      // Assert
      check(avisos).isNotEmpty();
    });
  });

  group('ExecutarSyncPosLoginUseCase.podeDeslogar', () {
    test('retorna true quando não há coletas pendentes', () async {
      // Arrange
      final useCase = ExecutarSyncPosLoginUseCase(
        pullService: _SpyPullService(),
        bemMaterialRepository: _SpyBemMaterialRepository(),
        obterColetasPendentesUseCase: _FakeObterPendentes(),
        agendarSync: () async {},
      );

      // Act
      final pode = await useCase.podeDeslogar();

      // Assert
      check(pode).isTrue();
    });
  });
}
