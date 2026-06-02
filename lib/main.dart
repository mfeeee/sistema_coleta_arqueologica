import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:workmanager/workmanager.dart';
import 'package:sistema_coleta_arqueologica/core/services/background_sync_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/log_capture.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/repositories/coleta_repository_impl.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/obter_coletas_pendentes_use_case.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/datasources/notificacao_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/repositories/notificacao_repository.dart';
import 'package:sistema_coleta_arqueologica/features/profile/data/datasources/preferencias_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/profile/data/repositories/preferencias_notificacao_repository.dart';

import 'core/constants/api_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/database/app_database.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/authenticated_http_client.dart';
import 'package:http/http.dart' as http;
import 'features/auth/auth_notifier.dart';
import 'core/di/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    LogCapture.registrar(
      details.exceptionAsString(),
      nome: 'FlutterError',
      erro: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  final prefs = await SharedPreferences.getInstance();
  final modoEscuroSalvo = prefs.getBool('pref_modo_escuro') ?? false;
  final temaModo = ValueNotifier<ThemeMode>(
    modoEscuroSalvo ? ThemeMode.dark : ThemeMode.light,
  );

  if (Platform.isAndroid) {
    await Workmanager().initialize(callbackDispatcher);
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
  }

  const secureStorage = SecureStorageService(FlutterSecureStorage());

  late final AppDatabase db;
  try {
    final passphrase = await secureStorage.getOrCreateDbPassphrase();
    db = await AppDatabase.open(passphrase);
  } catch (e) {
    log('Falha crítica ao abrir banco criptografado', error: e, name: 'Main');
    rethrow;
  }

  final plainHttpClient = http.Client();
  final authService = AuthService(
    secureStorage: secureStorage,
    httpClient: plainHttpClient,
    baseUrl: kApiBaseUrl,
  );

  final authenticatedClient = AuthenticatedHttpClient(
    secureStorage: secureStorage,
    authService: authService,
  );

  final coletaApiDatasource = ColetaApiDatasourceImpl(
    httpClient: authenticatedClient,
    secureStorage: secureStorage,
    baseUrl: kApiBaseUrl,
  );

  final coletaLocalDatasource = ColetaLocalDatasourceImpl(db);
  final coletaRepository = ColetaRepositoryImpl(coletaLocalDatasource);

  final pullService = PullService(
    apiDatasource: coletaApiDatasource,
    localRepository: coletaRepository,
  );

  final obterColetasPendentesUseCase = ObterColetasPendentesUseCase(
    coletaRepository,
  );

  final authNotifier = AuthNotifier(
    authService: authService,
    coletaRepository: coletaRepository,
    pullService: pullService,
    obterColetasPendentesUseCase: obterColetasPendentesUseCase,
  );

  authenticatedClient.onSessaoExpirada = authNotifier.sairPorSessaoExpirada;

  final dio = Dio(
    BaseOptions(
      baseUrl: kApiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  final notificacaoApiDatasource = NotificacaoApiDatasourceImpl(
    httpClient: authenticatedClient,
    secureStorage: secureStorage,
    baseUrl: kApiBaseUrl,
  );
  final notificacaoRepository = NotificacaoRepositoryImpl(
    notificacaoApiDatasource,
  );

  final preferenciasApiDatasource = PreferenciasApiDatasourceImpl(
    httpClient: authenticatedClient,
    secureStorage: secureStorage,
    baseUrl: kApiBaseUrl,
  );
  final preferenciasRepository = PreferenciasNotificacaoRepositoryImpl(
    prefs,
    apiDatasource: preferenciasApiDatasource,
  );

  // Agenda sync em background se já há sessão ativa.
  if ((await secureStorage.getJwt()) != null) {
    await BackgroundSyncService.agendar();
  }

  final router = createAppRouter(authNotifier);

  AppLinks().uriLinkStream.listen((uri) {
    if (uri.scheme == 'arqueopi' && uri.path == '/reset-password') {
      final token = uri.queryParameters['token'];
      final email = uri.queryParameters['email'];
      if (token != null && email != null) {
        router.go('/reset-password', extra: {'token': token, 'email': email});
      }
    }
  });

  runApp(
    AppScope.create(
      database: db,
      secureStorage: secureStorage,
      authNotifier: authNotifier,
      dio: dio,
      prefs: prefs,
      temaModo: temaModo,
      notificacaoRepository: notificacaoRepository,
      preferenciasRepository: preferenciasRepository,
      child: _ArqueoApp(router: router, temaModo: temaModo),
    ),
  );
}

class _ArqueoApp extends StatefulWidget {
  const _ArqueoApp({required this.router, required this.temaModo});

  final GoRouter router;
  final ValueNotifier<ThemeMode> temaModo;

  @override
  State<_ArqueoApp> createState() => _ArqueoAppState();
}

class _ArqueoAppState extends State<_ArqueoApp> {
  @override
  void initState() {
    super.initState();
    widget.temaModo.addListener(_onTemaAlterado);
  }

  @override
  void dispose() {
    widget.temaModo.removeListener(_onTemaAlterado);
    super.dispose();
  }

  void _onTemaAlterado() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ArqueoData',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: widget.temaModo.value,
      routerConfig: widget.router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
    );
  }
}
