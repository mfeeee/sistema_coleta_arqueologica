import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/entities/sync_resumo.dart';
import 'package:sistema_coleta_arqueologica/features/sync/presentation/viewmodels/sync_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_repository.dart';
import 'package:sistema_coleta_arqueologica/core/services/conectividade_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';

// --- Fakes ---

class _FakeSyncRepository extends Fake implements SyncRepository {
  int _pendentes;
  final SyncResumo resumo;

  _FakeSyncRepository({int pendentes = 0, SyncResumo? resumo})
    : _pendentes = pendentes,
      resumo = resumo ?? const SyncResumo(sucessos: 1, conflitos: 0, erros: 0);

  @override
  Future<int> contarPendentes() async => _pendentes;

  @override
  Future<SyncResumo> sincronizarTodas({
    void Function(String)? onProgresso,
  }) async {
    onProgresso?.call('Sincronizando...');
    _pendentes = 0;
    return resumo;
  }
}

class _FakeConectividadeService extends Fake implements ConectividadeService {
  final bool online;
  _FakeConectividadeService({this.online = true});

  @override
  Future<bool> verificar() async => online;
}

class _FakeSecureStorage extends Fake implements SecureStorageService {
  final String? token;
  _FakeSecureStorage({this.token = 'token-valido'});

  @override
  Future<String?> getJwt() async => token;
}

// --- Testes ---

void main() {
  group('SyncNotifier — padrão Observador', () {
    test('estado inicial é idle', () {
      final notifier = SyncNotifier(
        repository: _FakeSyncRepository(),
        secureStorage: _FakeSecureStorage(),
        conectividadeService: _FakeConectividadeService(),
      );
      check(notifier.state).equals(SyncState.idle);
      check(notifier.sincronizando).isFalse();
    });

    test('notifyListeners é chamado e estado muda para concluido', () async {
      final notifier = SyncNotifier(
        repository: _FakeSyncRepository(pendentes: 2),
        secureStorage: _FakeSecureStorage(),
        conectividadeService: _FakeConectividadeService(),
      );

      final estados = <SyncState>[];
      notifier.addListener(() => estados.add(notifier.state));

      await notifier.sincronizar();

      check(estados).contains(SyncState.sincronizando);
      check(estados.last).equals(SyncState.concluido);
      check(notifier.ultimoResumo).isNotNull();
    });

    test('sem conexão muda estado para semConexao', () async {
      final notifier = SyncNotifier(
        repository: _FakeSyncRepository(),
        secureStorage: _FakeSecureStorage(),
        conectividadeService: _FakeConectividadeService(online: false),
      );

      await notifier.sincronizar();

      check(notifier.state).equals(SyncState.semConexao);
      check(notifier.mensagemErro).isNotNull();
    });

    test('sem token muda estado para semToken', () async {
      final notifier = SyncNotifier(
        repository: _FakeSyncRepository(),
        secureStorage: _FakeSecureStorage(token: null),
        conectividadeService: _FakeConectividadeService(),
      );

      await notifier.sincronizar();

      check(notifier.state).equals(SyncState.semToken);
    });
  });
}
