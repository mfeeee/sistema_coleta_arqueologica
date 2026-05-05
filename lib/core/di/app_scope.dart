import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/sync_notifier.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/coleta/data/datasources/coleta_local_datasource.dart';
import '../../features/coleta/data/repositories/coleta_repository_impl.dart';
import '../../core/database/app_database.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.authNotifier,
    required this.syncNotifier,
    required this.coletaRepository,
    required this.mediaService,
    required super.child,
  });

  final AuthNotifier authNotifier;
  final SyncNotifier syncNotifier;
  final ColetaRepositoryImpl coletaRepository;
  final MediaService mediaService;

  factory AppScope.create({
    required AppDatabase database,
    required AuthNotifier authNotifier,
    required SyncNotifier syncNotifier,
    required Widget child,
  }) {
    final datasource = ColetaLocalDatasourceImpl(database);
    final coletaRepository = ColetaRepositoryImpl(datasource);
    final mediaService = MediaService(ImagePicker());

    return AppScope(
      authNotifier: authNotifier,
      syncNotifier: syncNotifier,
      coletaRepository: coletaRepository,
      mediaService: mediaService,
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
      mediaService != oldWidget.mediaService;
}
