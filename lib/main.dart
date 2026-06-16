import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:sistema_coleta_arqueologica/core/services/notification_service.dart';
import 'package:sistema_coleta_arqueologica/firebase_options.dart';
import 'core/l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:workmanager/workmanager.dart';
import 'package:sistema_coleta_arqueologica/core/services/background_sync_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/log_capture.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/data/datasources/bem_material_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/data/datasources/bem_material_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/data/repositories/bem_material_repository_impl.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/repositories/coleta_repository_impl.dart';
import 'package:sistema_coleta_arqueologica/features/auth/domain/usecases/executar_sync_pos_login_use_case.dart';
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
import 'core/network/dio_client.dart';
import 'core/services/profile_service.dart';
import 'features/auth/auth_notifier.dart';
import 'core/di/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationService.instance.initialize();
  } catch (e) {
    log(
      'Firebase initialization failed (likely missing config files)',
      error: e,
    );
  }

  await FMTCObjectBoxBackend().initialise();
  await const FMTCStore('arqueologico').manage.create();

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
  final idiomaAtual = ValueNotifier<Locale>(
    _localeSalva(prefs.getString('pref_idioma')),
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

  late final AuthNotifier authNotifier;

  final dioPublic = DioClient.public(baseUrl: kApiBaseUrl);
  final dioAuth = DioClient.authenticated(
    baseUrl: kApiBaseUrl,
    secureStorage: secureStorage,
    onSessionExpired: (msg) => authNotifier.sairPorSessaoExpirada(msg),
    onRefreshToken: () => authNotifier.authService.renovarToken(),
  );

  final authService = AuthService(secureStorage: secureStorage, dio: dioPublic);

  final profileService = ProfileService(dio: dioAuth);

  final coletaApiDatasource = ColetaApiDatasourceImpl(dio: dioAuth);

  final coletaLocalDatasource = ColetaLocalDatasourceImpl(db);
  final coletaRepository = ColetaRepositoryImpl(coletaLocalDatasource);

  final pullService = PullService(
    apiDatasource: coletaApiDatasource,
    localRepository: coletaRepository,
    secureStorage: secureStorage,
  );

  final obterColetasPendentesUseCase = ObterColetasPendentesUseCase(
    coletaRepository,
  );

  final bemMaterialApiDatasource = BemMaterialApiDatasourceImpl(dio: dioAuth);
  final bemMaterialRepository = BemMaterialRepositoryImpl(
    local: BemMaterialLocalDatasourceImpl(db),
    api: bemMaterialApiDatasource,
    secureStorage: secureStorage,
  );

  final executarSyncPosLogin = ExecutarSyncPosLoginUseCase(
    pullService: pullService,
    bemMaterialRepository: bemMaterialRepository,
    obterColetasPendentesUseCase: obterColetasPendentesUseCase,
    onSyncColetasConcluido: () => authNotifier.contadorSyncColetas.value++,
    onSyncBensConcluido: () => authNotifier.contadorSyncBens.value++,
    onAviso: (msg) => authNotifier.setarAviso(msg),
  );

  final notificacaoApiDatasource = NotificacaoApiDatasourceImpl(dio: dioAuth);
  final notificacaoRepository = NotificacaoRepositoryImpl(
    notificacaoApiDatasource,
  );

  authNotifier = AuthNotifier(
    authService: authService,
    executarSyncPosLogin: executarSyncPosLogin,
    notificacaoRepository: notificacaoRepository,
  );

  final preferenciasApiDatasource = PreferenciasApiDatasourceImpl(dio: dioAuth);
  final preferenciasRepository = PreferenciasNotificacaoRepositoryImpl(
    prefs,
    apiDatasource: preferenciasApiDatasource,
  );

  // Agenda sync em background se já há sessão ativa.
  if ((await secureStorage.getJwt()) != null) {
    await BackgroundSyncService.agendar();

    // Tenta registrar o token FCM se a sessão já estiver ativa ao iniciar o app
    NotificationService.instance.getToken().then((token) {
      if (token != null) {
        notificacaoRepository.vincularTokenFCM(token).catchError((e) {
          log(
            'Falha ao vincular token FCM na restauração',
            error: e,
            name: 'Main',
          );
        });
      }
    });
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
      dio: dioAuth,
      dioPublic: dioPublic,
      prefs: prefs,
      temaModo: temaModo,
      idiomaAtual: idiomaAtual,
      notificacaoRepository: notificacaoRepository,
      preferenciasRepository: preferenciasRepository,
      profileService: profileService,
      bemMaterialRepository: bemMaterialRepository,
      child: _ArqueoApp(
        router: router,
        temaModo: temaModo,
        idiomaAtual: idiomaAtual,
      ),
    ),
  );
}

Locale _localeSalva(String? salvo) {
  if (salvo == 'en_US') return const Locale('en', 'US');
  return const Locale('pt', 'BR');
}

class _ArqueoApp extends StatefulWidget {
  const _ArqueoApp({
    required this.router,
    required this.temaModo,
    required this.idiomaAtual,
  });

  final GoRouter router;
  final ValueNotifier<ThemeMode> temaModo;
  final ValueNotifier<Locale> idiomaAtual;

  @override
  State<_ArqueoApp> createState() => _ArqueoAppState();
}

class _ArqueoAppState extends State<_ArqueoApp> {
  @override
  void initState() {
    super.initState();
    widget.temaModo.addListener(_onTemaAlterado);
    widget.idiomaAtual.addListener(_onIdiomaAlterado);

    NotificationService.instance.onMessage.listen((message) {
      if (!mounted) return;
      final scope = AppScope.of(context);
      scope.unreadNotificationsCount.value++;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.title ?? 'Nova notificação'),
          action: SnackBarAction(
            label: 'Ver',
            onPressed: () => widget.router.push('/notificacoes'),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    widget.temaModo.removeListener(_onTemaAlterado);
    widget.idiomaAtual.removeListener(_onIdiomaAlterado);
    super.dispose();
  }

  void _onTemaAlterado() => setState(() {});
  void _onIdiomaAlterado() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ArqueoData',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: widget.temaModo.value,
      locale: widget.idiomaAtual.value,
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
