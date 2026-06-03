import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/services/auth_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/auth/domain/usecases/executar_sync_pos_login_use_case.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_remota_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/obter_coletas_pendentes_use_case.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeSecureStorageService extends SecureStorageService {
  _FakeSecureStorageService() : super(const FlutterSecureStorage());

  @override
  Future<void> saveJwt(String token) async {}

  @override
  Future<String?> getJwt() async => null;
}

class _FakeColetaRepository implements ColetaRepository {
  @override
  Future<List<ColetaEntity>> getPendentes() async => [];

  @override
  Future<List<ColetaEntity>> getAll() async => [];

  @override
  Future<ColetaEntity?> getById(String uuid) async => null;

  @override
  Future<int> contarTodas() async => 0;

  @override
  Future<int> contarPorStatus(StatusColeta status) async => 0;

  @override
  Future<List<ColetaEntity>> getRecentes(int limite) async => [];

  @override
  Future<void> salvar(ColetaEntity coleta) async {}

  @override
  Future<void> atualizarStatus(
    String uuid,
    dynamic status,
    int novaVersao,
  ) async {}

  @override
  Future<void> deletar(String uuid) async {}
}

class _FakeColetaApiDatasource implements ColetaApiDatasource {
  @override
  Future<ColetaPage> fetchMinhas({int page = 1}) async =>
      (items: <ColetaEntity>[], total: 0, temProxima: false);
}

class _FakePullService extends PullService {
  _FakePullService()
    : super(
        apiDatasource: _FakeColetaApiDatasource(),
        localRepository: _FakeColetaRepository(),
        secureStorage: _FakeSecureStorageService(),
      );

  @override
  Future<int> sincronizarPull(String usuarioId) async => 0;
}

class _SpyObterPendentesUseCase extends ObterColetasPendentesUseCase {
  _SpyObterPendentesUseCase() : super(_FakeColetaRepository());

  int chamadas = 0;
  List<ColetaEntity> retorno = [];

  @override
  Future<List<ColetaEntity>> call() async {
    chamadas++;
    return retorno;
  }
}

class _ErrandoObterPendentesUseCase extends ObterColetasPendentesUseCase {
  _ErrandoObterPendentesUseCase() : super(_FakeColetaRepository());

  @override
  Future<List<ColetaEntity>> call() => Future.error(Exception('erro simulado'));
}

class _FakeBemMaterialRepository implements BemMaterialRepository {
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
  @override
  Future<int> sincronizarBens({bool forcar = false}) async => 0;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaEntity _coletaPendente(String id) => ColetaEntity(
  id: id,
  usuarioId: 'u1',
  dataColeta: DateTime(2024),
  syncStatus: StatusColeta.pendente,
  nomeBem: 'Sítio $id',
  latitude: 0,
  longitude: 0,
  artefatos: const <ArtefatoBem>[],
  versao: 1,
  updatedAt: DateTime(2024),
  dadosColetados: const {},
);

final _respostaLoginOk = jsonEncode({
  'token': 'jwt_teste_123',
  'user': {
    'name': 'Pesquisador Teste',
    'id': '42',
    'email': 'teste@arqueologia.br',
    'classificacao': 'pesquisador',
  },
});

AuthService _authServiceOk() => AuthService(
  secureStorage: _FakeSecureStorageService(),
  httpClient: MockClient((_) async => http.Response(_respostaLoginOk, 200)),
  baseUrl: 'http://fake.local',
);

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('AuthNotifier — pendentes pós-login', () {
    test(
      'após login bem-sucedido, obterColetasPendentesUseCase.call() é invocado',
      () async {
        final spy = _SpyObterPendentesUseCase();
        final notifier = AuthNotifier(
          authService: _authServiceOk(),
          executarSyncPosLogin: ExecutarSyncPosLoginUseCase(
            pullService: _FakePullService(),
            bemMaterialRepository: _FakeBemMaterialRepository(),
            obterColetasPendentesUseCase: spy,
            agendarSync: () async {},
          ),
        );

        await notifier.login('teste@arqueologia.br', 'senha123');
        await Future<void>.delayed(Duration.zero);

        check(spy.chamadas).isGreaterThan(0);
      },
    );

    test('se pendentes > 0, agendarSync é chamado', () async {
      final spy = _SpyObterPendentesUseCase()..retorno = [_coletaPendente('x')];
      final chamouAgendar = <bool>[];

      final notifier = AuthNotifier(
        authService: _authServiceOk(),
        executarSyncPosLogin: ExecutarSyncPosLoginUseCase(
          pullService: _FakePullService(),
          bemMaterialRepository: _FakeBemMaterialRepository(),
          obterColetasPendentesUseCase: spy,
          agendarSync: () async => chamouAgendar.add(true),
        ),
      );

      await notifier.login('teste@arqueologia.br', 'senha123');
      await Future<void>.delayed(Duration.zero);

      check(chamouAgendar).isNotEmpty();
    });

    test('se pendentes == 0, agendarSync NÃO é chamado', () async {
      final spy = _SpyObterPendentesUseCase()..retorno = [];
      final chamouAgendar = <bool>[];

      final notifier = AuthNotifier(
        authService: _authServiceOk(),
        executarSyncPosLogin: ExecutarSyncPosLoginUseCase(
          pullService: _FakePullService(),
          bemMaterialRepository: _FakeBemMaterialRepository(),
          obterColetasPendentesUseCase: spy,
          agendarSync: () async => chamouAgendar.add(true),
        ),
      );

      await notifier.login('teste@arqueologia.br', 'senha123');
      await Future<void>.delayed(Duration.zero);

      check(chamouAgendar).isEmpty();
    });

    test(
      'erro no UseCase não impede que AuthStatus seja authenticated',
      () async {
        final notifier = AuthNotifier(
          authService: _authServiceOk(),
          executarSyncPosLogin: ExecutarSyncPosLoginUseCase(
            pullService: _FakePullService(),
            bemMaterialRepository: _FakeBemMaterialRepository(),
            obterColetasPendentesUseCase: _ErrandoObterPendentesUseCase(),
            agendarSync: () async {},
          ),
        );

        await notifier.login('teste@arqueologia.br', 'senha123');
        await Future<void>.delayed(Duration.zero);

        check(notifier.status).equals(AuthStatus.authenticated);
      },
    );
  });
}
