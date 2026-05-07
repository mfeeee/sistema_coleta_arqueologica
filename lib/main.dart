import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/repositories/coleta_repository_impl.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/database/app_database.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'features/auth/auth_notifier.dart';
import 'core/di/app_scope.dart';

const _baseUrl = 'https://sistemaarqueologicoapi-production.up.railway.app/api';

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

  final coletaApiDatasource = ColetaApiDatasourceImpl(
    httpClient: plainHttpClient,
    secureStorage: secureStorage,
    baseUrl: _baseUrl,
  );

  final coletaLocalDatasource = ColetaLocalDatasourceImpl(db);
  final coletaRepository = ColetaRepositoryImpl(coletaLocalDatasource);

  final pullService = PullService(
    apiDatasource: coletaApiDatasource,
    localRepository: coletaRepository,
  );

  final authNotifier = AuthNotifier(
    authService: authService,
    coletaRepository: coletaRepository,
    pullService: pullService,
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  runApp(
    AppScope.create(
      database: db,
      secureStorage: secureStorage,
      authNotifier: authNotifier,
      dio: dio,
      child: MaterialApp.router(
        title: 'Sistema de Coleta Arqueológica',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: createAppRouter(authNotifier),
      ),
    ),
  );
}
