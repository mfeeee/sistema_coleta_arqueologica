import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/data/datasources/bem_material_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_repository.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/sync_notifier.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/database/app_database.dart';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'core/services/auth_service.dart';
import 'features/auth/auth_notifier.dart';
import 'core/di/app_scope.dart';

const _baseUrl = 'http://localhost:8000';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    baseUrl: _baseUrl,
  );

  final authNotifier = AuthNotifier(authService: authService);
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  final syncApiDatasource = SyncApiDatasourceImpl(dio);
  final coletaLocalDatasource = ColetaLocalDatasourceImpl(db);
  final bemMaterialLocalDatasource = BemMaterialLocalDatasourceImpl(db);

  final syncRepository = SyncRepository(
    coletaDatasource: coletaLocalDatasource,
    bemMaterialDatasource: bemMaterialLocalDatasource,
    apiDatasource: syncApiDatasource,
  );

  final syncNotifier = SyncNotifier(
    repository: syncRepository,
    secureStorage: secureStorage,
  );

  runApp(
    SistemaColetaApp(
      authNotifier: authNotifier,
      syncNotifier: syncNotifier,
      database: db,
    ),
  );
}

class SistemaColetaApp extends StatefulWidget {
  const SistemaColetaApp({
    super.key,
    required this.authNotifier,
    required this.syncNotifier,
    required this.database,
  });

  final AuthNotifier authNotifier;
  final SyncNotifier syncNotifier;
  final AppDatabase database;

  @override
  State<SistemaColetaApp> createState() => _SistemaColetaAppState();
}

class _SistemaColetaAppState extends State<SistemaColetaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(widget.authNotifier);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope.create(
      database: widget.database,
      authNotifier: widget.authNotifier,
      syncNotifier: widget.syncNotifier,
      child: MaterialApp.router(
        title: 'Sistema de Coleta Arqueológica',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}
