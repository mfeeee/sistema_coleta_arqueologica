// lib/core/di/app_scope.dart
import 'package:flutter/widgets.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/sync/sync_service.dart';
import '../../features/coleta/data/datasources/bem_material_local_datasource.dart';
import '../../features/coleta/data/repositories/coleta_repository_impl.dart';
import '../../core/database/app_database.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.authNotifier,
    required this.syncService,
    required this.coletaRepository,
    required super.child,
  });

  final AuthNotifier authNotifier;
  final SyncService syncService;
  final ColetaRepositoryImpl coletaRepository;

  factory AppScope.create({
    required AppDatabase database,
    required AuthNotifier authNotifier,
    required SyncService syncService,
    required Widget child,
  }) {
    final datasource = BemMaterialLocalDatasourceImpl(database);
    final coletaRepository = ColetaRepositoryImpl(datasource);
    return AppScope(
      authNotifier: authNotifier,
      syncService: syncService,
      coletaRepository: coletaRepository,
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
      syncService != oldWidget.syncService ||
      coletaRepository != oldWidget.coletaRepository;
}
