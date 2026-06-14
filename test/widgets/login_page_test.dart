import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_coleta_arqueologica/core/l10n/app_localizations.dart';
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
import 'package:sistema_coleta_arqueologica/features/auth/domain/usecases/executar_sync_pos_login_use_case.dart';
import 'package:sistema_coleta_arqueologica/features/auth/pages/login_page.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_remota_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/obter_coletas_pendentes_use_case.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/services/foto_upload_service.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/coleta_sync_strategy.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_repository.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/entities/sync_resumo.dart';
import 'package:sistema_coleta_arqueologica/features/sync/presentation/viewmodels/sync_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/models/notificacao_model.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/repositories/notificacao_repository.dart';
import 'package:sistema_coleta_arqueologica/features/profile/data/models/preferencias_notificacao.dart';
import 'package:sistema_coleta_arqueologica/features/profile/data/repositories/preferencias_notificacao_repository.dart';
import 'package:sistema_coleta_arqueologica/core/services/profile_service.dart';
import '../helpers/stub_midia_repository.dart';

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
  @override
  Future<int> sincronizarBens({bool forcar = false}) async => 0;
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
  Future<ColetaPage> fetchMinhas({int page = 1}) async =>
      (items: <ColetaEntity>[], total: 0, temProxima: false);
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
  Future<int> contarPorStatus(dynamic status) async => 0;
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
  Future<void> deletar(String uuid) async {}
}

class _StubSyncApiDatasource implements SyncApiDatasource {
  @override
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    Map<String, dynamic>? dadosColetadosOverride,
    void Function(int tentativa, int max)? onTentativa,
  }) async =>
      SyncResultado(coletaId: coleta.id, status: SyncResultStatus.sucesso);
}

// ---------------------------------------------------------------------------
// Fake do AuthNotifier com controle de estado
// ---------------------------------------------------------------------------

final _stubAuthService = AuthService(
  secureStorage: _StubSecureStorage(),
  dio: Dio(),
);

final _stubPullService = PullService(
  apiDatasource: _StubColetaApiDatasource(),
  localRepository: _StubColetaRepository(),
  secureStorage: _StubSecureStorage(),
);

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier()
    : super(
        authService: _stubAuthService,
        executarSyncPosLogin: ExecutarSyncPosLoginUseCase(
          pullService: _stubPullService,
          bemMaterialRepository: _StubBemMaterialRepository(),
          obterColetasPendentesUseCase: ObterColetasPendentesUseCase(
            _StubColetaRepository(),
          ),
          agendarSync: () async {},
        ),
      );

  bool loginChamado = false;
  String? emailRecebido;
  Completer<void>? _aguardando;
  String? _erroFake;

  @override
  bool get isLoading => _aguardando != null && !_aguardando!.isCompleted;

  @override
  String? get errorMessage => _erroFake;

  @override
  Future<void> login(String email, String password) async {
    loginChamado = true;
    emailRecebido = email;
    _aguardando = Completer();
    notifyListeners();
    await _aguardando!.future;
    notifyListeners();
  }

  void completar() {
    _aguardando?.complete();
    _aguardando = null;
  }

  void definirErro(String mensagem) {
    _erroFake = mensagem;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Auxiliar de montagem
// ---------------------------------------------------------------------------

SyncNotifier _criarStubSyncNotifier() => SyncNotifier(
  repository: SyncRepository(
    coletaDatasource: _StubColetaLocalDatasource(),
    strategy: ColetaSyncStrategy(
      apiDatasource: _StubSyncApiDatasource(),
      fotoUploadService: FotoUploadService(Dio()),
    ),
  ),
  secureStorage: _StubSecureStorage(),
  conectividadeService: ConectividadeService(),
);

Future<Widget> _montarLoginPage(_FakeAuthNotifier notifier) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (_, __) => const Scaffold(body: Text('Cadastro')),
      ),
      GoRoute(
        path: '/recover-password',
        builder: (_, __) => const Scaffold(body: Text('Recuperar Senha')),
      ),
    ],
  );

  final dio = Dio();

  return AppScope(
    authNotifier: notifier,
    syncNotifier: _criarStubSyncNotifier(),
    coletaRepository: _StubColetaRepository(),
    bemMaterialRepository: _StubBemMaterialRepository(),
    notificacaoRepository: _StubNotificacaoRepository(),
    preferenciasRepository: _StubPreferenciasRepository(),
    midiaRepository: StubMidiaRepository(),
    uploadMidiaUseCase: StubUploadMidiaUseCase(),
    mediaService: MediaService(ImagePicker()),
    conectividadeService: ConectividadeService(),
    prefs: prefs,
    temaModo: ValueNotifier(ThemeMode.light),
    idiomaAtual: ValueNotifier(const Locale('pt', 'BR')),
    fotoPerfilPath: ValueNotifier(null),
    profileService: ProfileService(dio: dio),
    secureStorage: _StubSecureStorage(),
    dioPublic: dio,
    child: MaterialApp.router(
      routerConfig: router,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
    ),
  );
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  testWidgets('formulário vazio: botão Entrar está desabilitado', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(await _montarLoginPage(notifier));
    await tester.pumpAndSettle();

    final botao = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton).first,
    );
    expect(botao.onPressed, isNull);
  });

  testWidgets('e-mail inválido sem senha: botão permanece desabilitado', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(await _montarLoginPage(notifier));
    await tester.pumpAndSettle();

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'nao-e-email');
    await tester.enterText(campos.at(1), 'senha123');
    await tester.pump();

    final botao = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton).first,
    );
    expect(botao.onPressed, isNull);
  });

  testWidgets('e-mail e senha válidos: botão Entrar fica habilitado', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(await _montarLoginPage(notifier));
    await tester.pumpAndSettle();

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'usuario@example.com');
    await tester.enterText(campos.at(1), 'senha123');
    await tester.pump();

    final botao = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton).first,
    );
    expect(botao.onPressed, isNotNull);
  });

  testWidgets('submissão com dados válidos chama notifier.login', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(await _montarLoginPage(notifier));
    await tester.pumpAndSettle();

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'usuario@example.com');
    await tester.enterText(campos.at(1), 'senha123');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump();

    expect(notifier.loginChamado, isTrue);
    expect(notifier.emailRecebido, 'usuario@example.com');
  });

  testWidgets('durante carregamento: botão Entrar fica desabilitado', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(await _montarLoginPage(notifier));
    await tester.pumpAndSettle();

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'usuario@example.com');
    await tester.enterText(campos.at(1), 'senha123');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump();

    expect(notifier.isLoading, isTrue);
    final botao = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton).first,
    );
    expect(botao.onPressed, isNull);
  });

  testWidgets('mensagem de erro do notifier é exibida na tela', (tester) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(await _montarLoginPage(notifier));
    await tester.pumpAndSettle();

    notifier.definirErro('Credenciais inválidas.');
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });
}
