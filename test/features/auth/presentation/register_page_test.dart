import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/services/auth_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/conectividade_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/auth/pages/register_page.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_repository.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/sync_notifier.dart';

// ---------------------------------------------------------------------------
// Stubs de infraestrutura (nunca chamados nos testes de RegisterPage)
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
    required String bearerToken,
  }) async =>
      SyncResultado(coletaId: coleta.id, status: SyncResultStatus.sucesso);
}

// ---------------------------------------------------------------------------
// Fake do AuthNotifier — rastreia chamadas e simula estado de carregamento
// ---------------------------------------------------------------------------

final _stubAuthService = AuthService(
  secureStorage: _StubSecureStorage(),
  httpClient: _StubHttpClient(),
  baseUrl: '',
);

final _stubPullService = PullService(
  apiDatasource: _StubColetaApiDatasource(),
  localRepository: _StubColetaRepository(),
);

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier()
    : super(
        authService: _stubAuthService,
        coletaRepository: _StubColetaRepository(),
        pullService: _stubPullService,
      );

  bool registerChamado = false;
  Completer<void>? _aguardando;
  String? _erroFake;

  @override
  bool get isLoading => _aguardando != null && !_aguardando!.isCompleted;

  @override
  String? get errorMessage => _erroFake;

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String classificacao,
  }) async {
    registerChamado = true;
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
// Auxiliar de montagem do widget
// ---------------------------------------------------------------------------

SyncNotifier _criarStubSyncNotifier() => SyncNotifier(
  repository: SyncRepository(
    coletaDatasource: _StubColetaLocalDatasource(),
    apiDatasource: _StubSyncApiDatasource(),
  ),
  secureStorage: _StubSecureStorage(),
  conectividadeService: ConectividadeService(),
);

Widget _montarWidget(_FakeAuthNotifier notifier) {
  final router = GoRouter(
    initialLocation: '/register',
    routes: [
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(
        path: '/home',
        builder: (_, __) => const Scaffold(body: Text('Início')),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const Scaffold(body: Text('Login')),
      ),
    ],
  );

  return AppScope(
    authNotifier: notifier,
    syncNotifier: _criarStubSyncNotifier(),
    coletaRepository: _StubColetaRepository(),
    bemMaterialRepository: _StubBemMaterialRepository(),
    mediaService: MediaService(ImagePicker()),
    conectividadeService: ConectividadeService(),
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Helpers de preenchimento do formulário
// ---------------------------------------------------------------------------

Future<void> _preencherFormularioValido(WidgetTester tester) async {
  final campos = find.byType(TextFormField);
  await tester.enterText(campos.at(0), 'João Silva');
  await tester.enterText(campos.at(1), 'joao@example.com');
  await tester.enterText(campos.at(2), 'senha12345');
  await tester.enterText(campos.at(3), 'senha12345');
  await tester.pumpAndSettle();
}

Future<void> _tocarBotaoSubmissao(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  testWidgets('formulário vazio: botão Criar Conta está desabilitado', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(_montarWidget(notifier));
    await tester.pumpAndSettle();

    final botao = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(botao.onPressed, isNull);
  });

  testWidgets('formulário válido: botão Criar Conta fica habilitado', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(_montarWidget(notifier));
    await tester.pumpAndSettle();

    await _preencherFormularioValido(tester);

    final botao = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(botao.onPressed, isNotNull);
  });

  testWidgets('submissão com formulário válido chama notifier.register', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(_montarWidget(notifier));
    await tester.pumpAndSettle();

    await _preencherFormularioValido(tester);
    await _tocarBotaoSubmissao(tester);

    expect(notifier.registerChamado, isTrue);
  });

  testWidgets('durante o carregamento: botão Criar Conta fica desabilitado', (
    tester,
  ) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(_montarWidget(notifier));
    await tester.pumpAndSettle();

    await _preencherFormularioValido(tester);
    await _tocarBotaoSubmissao(tester);

    expect(notifier.isLoading, isTrue);
    final botao = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(botao.onPressed, isNull);
  });

  testWidgets('mensagem de erro do notifier é exibida na tela', (tester) async {
    final notifier = _FakeAuthNotifier();
    await tester.pumpWidget(_montarWidget(notifier));
    await tester.pumpAndSettle();

    notifier.definirErro('E-mail já cadastrado.');
    await tester.pump();

    expect(find.text('E-mail já cadastrado.'), findsOneWidget);
  });
}
