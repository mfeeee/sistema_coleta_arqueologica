import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/services/auth_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/conectividade_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/obter_coletas_pendentes_use_case.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/services/foto_upload_service.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_repository.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/sync_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/sync/presentation/pages/sync_page.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/models/notificacao_model.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/repositories/notificacao_repository.dart';
import 'package:sistema_coleta_arqueologica/features/profile/data/models/preferencias_notificacao.dart';
import 'package:sistema_coleta_arqueologica/features/profile/data/repositories/preferencias_notificacao_repository.dart';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// Stubs de infraestrutura
// ---------------------------------------------------------------------------

class _StubSecureStorage extends SecureStorageService {
  _StubSecureStorage() : super(const FlutterSecureStorage());

  @override
  Future<void> saveJwt(String token) async {}

  @override
  Future<String?> getJwt() async => null;

  @override
  Future<void> clearAll() async {}
}

class _StubHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      Future.error(UnsupportedError('stub'));
}

class _StubColetaRepository implements ColetaRepository {
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
  Future<void> atualizarStatus(
    String uuid,
    dynamic status,
    int novaVersao,
  ) async {}
  @override
  Future<void> deletar(String uuid) async {}
}

class _StubBemMaterialRepository implements BemMaterialRepository {
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

class _StubNotificacaoRepository implements NotificacaoRepository {
  @override
  Future<List<NotificacaoModel>> buscarNotificacoes() async => [];
  @override
  Future<void> marcarComoLida(int id) async {}
}

class _StubPreferenciasRepository implements PreferenciasNotificacaoRepository {
  @override
  Future<PreferenciasNotificacao> carregar() async =>
      const PreferenciasNotificacao();
  @override
  Future<void> salvar(PreferenciasNotificacao prefs) async {}
}

class _StubColetaApiDatasource implements ColetaApiDatasource {
  @override
  Future<List<ColetaEntity>> fetchMinhas({int page = 1}) async => [];
}

class _StubColetaLocalDatasource implements ColetaLocalDatasource {
  @override
  Future<List<ColetaModel>> getAll() async => [];
  @override
  Future<List<ColetaModel>> getPendentes() async => [];
  @override
  Future<ColetaModel?> getById(String uuid) async => null;
  @override
  Future<int> contarTodas() async => 0;
  @override
  Future<int> contarPorStatus(StatusColeta status) async => 0;
  @override
  Future<List<ColetaModel>> getRecentes(int limite) async => [];
  @override
  Future<void> inserir(ColetaModel coleta) async {}
  @override
  Future<void> atualizarStatus(
    String uuid,
    StatusColeta status,
    int novaVersao,
  ) async {}
  @override
  Future<void> salvarFotosUrls(String uuid, List<String> urls) async {}
  @override
  Future<void> deletar(String uuid) async {}
}

class _StubSyncApiDatasource implements SyncApiDatasource {
  @override
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    required String bearerToken,
    Map<String, dynamic>? dadosColetadosOverride,
    void Function(int tentativa, int max)? onTentativa,
  }) async =>
      SyncResultado(coletaId: coleta.id, status: SyncResultStatus.sucesso);
}

// ---------------------------------------------------------------------------
// Fake do SyncNotifier com estado controlável
// ---------------------------------------------------------------------------

class _FakeSyncNotifier extends SyncNotifier {
  _FakeSyncNotifier({
    bool fakeSincronizando = false,
    SyncResumo? fakeResumo,
    SyncState fakeState = SyncState.idle,
    int fakePendentes = 0,
  }) : _fakeSincronizando = fakeSincronizando,
       _fakeResumo = fakeResumo,
       _fakeState = fakeState,
       _fakePendentes = fakePendentes,
       super(
         repository: SyncRepository(
           coletaDatasource: _StubColetaLocalDatasource(),
           apiDatasource: _StubSyncApiDatasource(),
           fotoUploadService: FotoUploadService(Dio()),
         ),
         secureStorage: _StubSecureStorage(),
         conectividadeService: ConectividadeService(),
       );

  final bool _fakeSincronizando;
  final SyncResumo? _fakeResumo;
  final SyncState _fakeState;
  final int _fakePendentes;

  @override
  bool get sincronizando => _fakeSincronizando;

  @override
  SyncResumo? get ultimoResumo => _fakeResumo;

  @override
  SyncState get state => _fakeState;

  @override
  int get pendentes => _fakePendentes;

  @override
  Future<void> carregarPendentes() async {}

  @override
  Future<void> sincronizar() async {}
}

// ---------------------------------------------------------------------------
// Auxiliar de montagem
// ---------------------------------------------------------------------------

AuthNotifier _criarStubAuthNotifier() {
  final authService = AuthService(
    secureStorage: _StubSecureStorage(),
    httpClient: _StubHttpClient(),
    baseUrl: '',
  );
  return AuthNotifier(
    authService: authService,
    coletaRepository: _StubColetaRepository(),
    pullService: PullService(
      apiDatasource: _StubColetaApiDatasource(),
      localRepository: _StubColetaRepository(),
    ),
    obterColetasPendentesUseCase: ObterColetasPendentesUseCase(
      _StubColetaRepository(),
    ),
    agendarSync: () async {},
  );
}

Future<Widget> _montarSyncPage(_FakeSyncNotifier syncNotifier) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  final router = GoRouter(
    initialLocation: '/sync',
    routes: [GoRoute(path: '/sync', builder: (_, __) => const SyncPage())],
  );

  return AppScope(
    authNotifier: _criarStubAuthNotifier(),
    syncNotifier: syncNotifier,
    coletaRepository: _StubColetaRepository(),
    bemMaterialRepository: _StubBemMaterialRepository(),
    notificacaoRepository: _StubNotificacaoRepository(),
    preferenciasRepository: _StubPreferenciasRepository(),
    mediaService: MediaService(ImagePicker()),
    conectividadeService: ConectividadeService(),
    prefs: prefs,
    temaModo: ValueNotifier(ThemeMode.light),
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  testWidgets('estado sincronizando exibe CircularProgressIndicator no botão', (
    tester,
  ) async {
    final notifier = _FakeSyncNotifier(
      fakeSincronizando: true,
      fakeState: SyncState.sincronizando,
    );
    await tester.pumpWidget(await _montarSyncPage(notifier));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('estado sincronizando desabilita o botão de sincronização', (
    tester,
  ) async {
    final notifier = _FakeSyncNotifier(
      fakeSincronizando: true,
      fakeState: SyncState.sincronizando,
    );
    await tester.pumpWidget(await _montarSyncPage(notifier));
    await tester.pump();

    final botao = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton).first,
    );
    expect(botao.onPressed, isNull);
  });

  testWidgets('estado concluído com sucesso exibe mensagem de confirmação', (
    tester,
  ) async {
    final notifier = _FakeSyncNotifier(
      fakeState: SyncState.concluido,
      fakeResumo: const SyncResumo(sucessos: 3, conflitos: 0, erros: 0),
    );
    await tester.pumpWidget(await _montarSyncPage(notifier));
    await tester.pump();

    expect(find.text('Tudo sincronizado com sucesso!'), findsOneWidget);
  });

  testWidgets('estado concluído com conflitos exibe contagem de conflitos', (
    tester,
  ) async {
    final notifier = _FakeSyncNotifier(
      fakeState: SyncState.concluido,
      fakeResumo: const SyncResumo(sucessos: 1, conflitos: 2, erros: 0),
    );
    await tester.pumpWidget(await _montarSyncPage(notifier));
    await tester.pump();

    expect(find.textContaining('2 conflito(s)'), findsWidgets);
  });

  testWidgets('estado idle exibe botão de sincronização habilitado', (
    tester,
  ) async {
    final notifier = _FakeSyncNotifier(fakeState: SyncState.idle);
    await tester.pumpWidget(await _montarSyncPage(notifier));
    await tester.pump();

    final botao = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton).first,
    );
    expect(botao.onPressed, isNotNull);
  });
}
