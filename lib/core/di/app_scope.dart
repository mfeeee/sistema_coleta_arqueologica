// lib/core/di/app_scope.dart
import 'package:flutter/widgets.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/sync/sync_service.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.authNotifier,
    required this.syncService,
    required super.child,
  });

  final AuthNotifier authNotifier;
  final SyncService syncService;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope não encontrado na árvore de widgets');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      authNotifier != oldWidget.authNotifier ||
      syncService != oldWidget.syncService;
}