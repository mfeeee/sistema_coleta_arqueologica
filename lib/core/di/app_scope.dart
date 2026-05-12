import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/services/conectividade_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';

import '../../features/sync/domain/sync_notifier.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/coleta/data/datasources/coleta_local_datasource.dart';
import '../../features/bem_material/data/datasources/bem_material_local_datasource.dart';
import '../../features/coleta/data/repositories/coleta_repository_impl.dart';
import '../../features/bem_material/data/repositories/bem_material_repository_impl.dart';
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
    required this.mediaService,
    required this.conectividadeService,
    required super.child,
  });

  final AuthNotifier authNotifier;
  final SyncNotifier syncNotifier;
  final ColetaRepository coletaRepository;
  final BemMaterialRepository bemMaterialRepository;
  final MediaService mediaService;
  final ConectividadeService conectividadeService;

  factory AppScope.create({
    required AppDatabase database,
    required SecureStorageService secureStorage,
    required AuthNotifier authNotifier,
    required Dio dio,
    required Widget child,
  }) {
    final coletaDatasource = ColetaLocalDatasourceImpl(database);
    final bemMaterialDatasource = BemMaterialLocalDatasourceImpl(database);

    final coletaRepository = ColetaRepositoryImpl(coletaDatasource);
    final bemMaterialRepository = BemMaterialRepositoryImpl(
      bemMaterialDatasource,
    );

    final syncApiDatasource = SyncApiDatasourceImpl(dio);
    final syncRepository = SyncRepository(
      coletaDatasource: coletaDatasource,
      apiDatasource: syncApiDatasource,
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
      mediaService: mediaService,
      conectividadeService: conectividadeService,
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
      mediaService != oldWidget.mediaService ||
      conectividadeService != oldWidget.conectividadeService;
}
