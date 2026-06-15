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
import 'package:sistema_coleta_arqueologica/features/media/domain/repositories/midia_repository.dart';
import 'package:sistema_coleta_arqueologica/features/media/domain/usecases/upload_midia_usecase.dart';
import 'package:sistema_coleta_arqueologica/features/media/data/repositories/midia_repository_impl.dart';
import 'package:sistema_coleta_arqueologica/features/media/data/datasources/midia_remote_datasource.dart';

import '../../features/sync/presentation/viewmodels/sync_notifier.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/coleta/data/datasources/coleta_local_datasource.dart';
import '../../features/coleta/data/repositories/coleta_repository_impl.dart';
import '../../features/sync/data/coleta_sync_strategy.dart';
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
    required this.midiaRepository,
    required this.uploadMidiaUseCase,
    required this.mediaService,
    required this.conectividadeService,
    required this.prefs,
    required this.temaModo,
    required this.idiomaAtual,
    required this.fotoPerfilPath,
    required this.unreadNotificationsCount,
    required this.profileService,
    required this.secureStorage,
    required this.dioPublic,
    required super.child,
  });

  final AuthNotifier authNotifier;
  final SyncNotifier syncNotifier;
  final ColetaRepository coletaRepository;
  final BemMaterialRepository bemMaterialRepository;
  final NotificacaoRepository notificacaoRepository;
  final PreferenciasNotificacaoRepository preferenciasRepository;
  final MidiaRepository midiaRepository;
  final UploadMidiaUseCase uploadMidiaUseCase;
  final MediaService mediaService;
  final ConectividadeService conectividadeService;
  final SharedPreferences prefs;
  final ValueNotifier<ThemeMode> temaModo;
  final ValueNotifier<Locale> idiomaAtual;
  final ValueNotifier<String?> fotoPerfilPath;
  final ValueNotifier<int> unreadNotificationsCount;
  final ProfileService profileService;
  final SecureStorageService secureStorage;
  final Dio dioPublic;

  factory AppScope.create({
    required AppDatabase database,
    required SecureStorageService secureStorage,
    required AuthNotifier authNotifier,
    required Dio dio,
    required Dio dioPublic,
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
      strategy: ColetaSyncStrategy(
        apiDatasource: syncApiDatasource,
        fotoUploadService: fotoUploadService,
      ),
    );
    final conectividadeService = ConectividadeService();

    final syncNotifier = SyncNotifier(
      repository: syncRepository,
      secureStorage: secureStorage,
      conectividadeService: conectividadeService,
    );

    final mediaService = MediaService(ImagePicker());

    final midiaRemoteDatasource = MidiaRemoteDatasourceImpl(dio: dio);
    final midiaRepository = MidiaRepositoryImpl(
      remoteDatasource: midiaRemoteDatasource,
    );
    final uploadMidiaUseCase = UploadMidiaUseCase(midiaRepository);

    return AppScope(
      authNotifier: authNotifier,
      syncNotifier: syncNotifier,
      coletaRepository: coletaRepository,
      bemMaterialRepository: bemMaterialRepository,
      notificacaoRepository: notificacaoRepository,
      preferenciasRepository: preferenciasRepository,
      midiaRepository: midiaRepository,
      uploadMidiaUseCase: uploadMidiaUseCase,
      mediaService: mediaService,
      conectividadeService: conectividadeService,
      prefs: prefs,
      temaModo: temaModo,
      idiomaAtual: idiomaAtual,
      fotoPerfilPath: ValueNotifier<String?>(null),
      unreadNotificationsCount: ValueNotifier<int>(0),
      profileService: profileService,
      secureStorage: secureStorage,
      dioPublic: dioPublic,
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
      midiaRepository != oldWidget.midiaRepository ||
      uploadMidiaUseCase != oldWidget.uploadMidiaUseCase ||
      mediaService != oldWidget.mediaService ||
      conectividadeService != oldWidget.conectividadeService ||
      prefs != oldWidget.prefs ||
      temaModo != oldWidget.temaModo ||
      idiomaAtual != oldWidget.idiomaAtual ||
      fotoPerfilPath != oldWidget.fotoPerfilPath ||
      unreadNotificationsCount != oldWidget.unreadNotificationsCount ||
      profileService != oldWidget.profileService ||
      secureStorage != oldWidget.secureStorage ||
      dioPublic != oldWidget.dioPublic;
}
