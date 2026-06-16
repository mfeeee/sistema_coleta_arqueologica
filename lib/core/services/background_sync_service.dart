import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:workmanager/workmanager.dart';
import '../database/app_database.dart';
import '../network/dio_client.dart';
import 'foto_upload_service.dart';
import 'secure_storage_service.dart';
import '../../features/coleta/data/datasources/coleta_local_datasource.dart';
import '../../features/sync/data/coleta_sync_strategy.dart';
import '../../features/sync/data/sync_api_datasource.dart';
import '../../features/sync/data/sync_repository.dart';

// Duplicado intencionalmente: o callbackDispatcher roda em isolate separado,
// sem acesso às constantes do main.dart.
const _kBaseUrl =
    'https://sistemaarqueologicoapi-production.up.railway.app/api';
const _kTaskTag = 'arqueodata_sync';
const _kTaskName = 'sincronizacao_periodica';

/// Ponto de entrada do WorkManager — deve ser top-level e anotado.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, _) async {
    try {
      log('BackgroundSync iniciado: $taskName', name: 'BackgroundSync');
      await _executarSync();
      return true;
    } catch (e, st) {
      log(
        'BackgroundSync falhou',
        error: e,
        stackTrace: st,
        name: 'BackgroundSync',
      );
      return false;
    }
  });
}

Future<void> _executarSync() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
  }

  const secureStorage = SecureStorageService(FlutterSecureStorage());

  final token = await secureStorage.getJwt();
  if (token == null) {
    log('BackgroundSync ignorado: sem token JWT', name: 'BackgroundSync');
    return;
  }

  final passphrase = await secureStorage.getOrCreateDbPassphrase();
  final db = await AppDatabase.open(passphrase);

  try {
    final dioAuth = DioClient.authenticated(
      baseUrl: _kBaseUrl,
      secureStorage: secureStorage,
    );

    final syncRepository = SyncRepository(
      coletaDatasource: ColetaLocalDatasourceImpl(db),
      strategy: ColetaSyncStrategy(
        apiDatasource: SyncApiDatasourceImpl(dioAuth),
        fotoUploadService: FotoUploadService(dioAuth),
      ),
      coletaApiDatasource: ColetaApiDatasourceImpl(dio: dioAuth),
    );

    final pendentes = await syncRepository.contarPendentes();
    if (pendentes == 0) {
      log('BackgroundSync: sem pendentes', name: 'BackgroundSync');
      return;
    }

    final resumo = await syncRepository.sincronizarTodas();
    log(
      'BackgroundSync concluído — '
      '✓${resumo.sucessos} ✗${resumo.conflitos} ~${resumo.erros}',
      name: 'BackgroundSync',
    );
  } finally {
    await db.close();
  }
}

/// Responsável por agendar e cancelar a task de sync periódico.
/// No-op em plataformas não-Android.
abstract final class BackgroundSyncService {
  static Future<void> agendar() async {
    if (!Platform.isAndroid) return;
    await Workmanager().registerPeriodicTask(
      _kTaskTag,
      _kTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
    log('BackgroundSync agendado', name: 'BackgroundSyncService');
  }

  static Future<void> cancelar() async {
    if (!Platform.isAndroid) return;
    await Workmanager().cancelByTag(_kTaskTag);
    log('BackgroundSync cancelado', name: 'BackgroundSyncService');
  }
}
