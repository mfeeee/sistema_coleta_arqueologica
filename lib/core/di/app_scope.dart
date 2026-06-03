import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_coleta_arqueologica/core/services/conectividade_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/foto_upload_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/profile_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/repositories/notificacao_repository.dart';
import 'package:sistema_coleta_arqueologica/features/profile/data/repositories/preferencias_notificacao_repository.dart';

import '../../features/sync/domain/sync_notifier.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/coleta/data/datasources/coleta_local_datasource.dart';
import '../../features/coleta/data/repositories/coleta_repository_impl.dart';
import '../../features/sync/data/sync_api_datasource.dart';
import '../../features/sync/data/sync_repository.dart';
import '../../core/database/app_database.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.authNotifier,
    required this.syncNotifier,
    required this.coletaRepository,
    required this.bemMaterialRepository,
    required this.notificacaoRepository,
    required this.preferenciasRepository,
    required this.mediaService,
    required this.conectividadeService,
    required this.prefs,
    required this.temaModo,
    required this.idiomaAtual,
    required this.fotoPerfilPath,
    required this.profileService,
    required this.secureStorage,
    required super.child,
  });

  final AuthNotifier authNotifier;
  final SyncNotifier syncNotifier;
  final ColetaRepository coletaRepository;
  final BemMaterialRepository bemMaterialRepository;
  final NotificacaoRepository notificacaoRepository;
  final PreferenciasNotificacaoRepository preferenciasRepository;
  final MediaService mediaService;
  final ConectividadeService conectividadeService;
  final SharedPreferences prefs;
  final ValueNotifier<ThemeMode> temaModo;
  final ValueNotifier<Locale> idiomaAtual;
  final ValueNotifier<String?> fotoPerfilPath;
  final ProfileService profileService;
  final SecureStorageService secureStorage;

  factory AppScope.create({
    required AppDatabase database,
    required SecureStorageService secureStorage,
    required AuthNotifier authNotifier,
    required Dio dio,
    required SharedPreferences prefs,
    required ValueNotifier<ThemeMode> temaModo,
    required ValueNotifier<Locale> idiomaAtual,
    required NotificacaoRepository notificacaoRepository,
    required PreferenciasNotificacaoRepository preferenciasRepository,
    required ProfileService profileService,
    required BemMaterialRepository bemMaterialRepository,
    required Widget child,
  }) {
    final coletaDatasource = ColetaLocalDatasourceImpl(database);
    final coletaRepository = ColetaRepositoryImpl(coletaDatasource);

    final syncApiDatasource = SyncApiDatasourceImpl(dio);
    final fotoUploadService = FotoUploadService(dio);
    final syncRepository = SyncRepository(
      coletaDatasource: coletaDatasource,
      apiDatasource: syncApiDatasource,
      fotoUploadService: fotoUploadService,
    );
    final conectividadeService = ConectividadeService();

    final syncNotifier = SyncNotifier(
      repository: syncRepository,
      secureStorage: secureStorage,
      conectividadeService: conectividadeService,
    );

    final mediaService = MediaService(ImagePicker());

    return AppScope(
      authNotifier: authNotifier,
      syncNotifier: syncNotifier,
      coletaRepository: coletaRepository,
      bemMaterialRepository: bemMaterialRepository,
      notificacaoRepository: notificacaoRepository,
      preferenciasRepository: preferenciasRepository,
      mediaService: mediaService,
      conectividadeService: conectividadeService,
      prefs: prefs,
      temaModo: temaModo,
      idiomaAtual: idiomaAtual,
      fotoPerfilPath: ValueNotifier<String?>(null),
      profileService: profileService,
      secureStorage: secureStorage,
      child: child,
    );
  }

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope não encontrado na árvore de widgets');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      authNotifier != oldWidget.authNotifier ||
      syncNotifier != oldWidget.syncNotifier ||
      coletaRepository != oldWidget.coletaRepository ||
      bemMaterialRepository != oldWidget.bemMaterialRepository ||
      notificacaoRepository != oldWidget.notificacaoRepository ||
      preferenciasRepository != oldWidget.preferenciasRepository ||
      mediaService != oldWidget.mediaService ||
      conectividadeService != oldWidget.conectividadeService ||
      prefs != oldWidget.prefs ||
      temaModo != oldWidget.temaModo ||
      idiomaAtual != oldWidget.idiomaAtual ||
      fotoPerfilPath != oldWidget.fotoPerfilPath ||
      profileService != oldWidget.profileService ||
      secureStorage != oldWidget.secureStorage;
}
