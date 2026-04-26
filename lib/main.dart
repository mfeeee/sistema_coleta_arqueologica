import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/database/app_database.dart';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'core/services/auth_service.dart';
import 'core/services/authenticated_http_client.dart';
import 'features/auth/auth_notifier.dart';
import 'features/sync/sync_service.dart';

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

  final authHttpClient = AuthenticatedHttpClient(
    secureStorage: secureStorage,
    authService: authService,
  );

  runApp(
    SistemaColetaApp(
      database: db,
      authNotifier: AuthNotifier(authService: authService),
      syncService: SyncService(
        database: db,
        httpClient: authHttpClient,
        baseUrl: _baseUrl,
      ),
    ),
  );
}

class SistemaColetaApp extends StatelessWidget {
  const SistemaColetaApp({
    super.key,
    required this.database,
    required this.authNotifier,
    required this.syncService,
  });

  final AppDatabase database;
  final AuthNotifier authNotifier;
  final SyncService syncService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sistema de Coleta Arqueológica',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
