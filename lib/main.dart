import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/database/app_database.dart';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/secure_storage_service.dart';

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

  runApp(SistemaColetaApp(database: db, secureStorage: secureStorage));
}

class SistemaColetaApp extends StatelessWidget {
  const SistemaColetaApp({
    super.key,
    required this.database,
    required this.secureStorage,
  });

  final AppDatabase database;
  final SecureStorageService secureStorage;

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
