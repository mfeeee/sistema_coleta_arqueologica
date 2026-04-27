import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../core/database/app_database.dart';
import '../../core/database/enums/status_coleta.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SyncService extends ChangeNotifier {
  SyncService({
    required this.database,
    required this.httpClient,
    required this.baseUrl,
  });

  final AppDatabase database;
  final http.Client httpClient;
  final String baseUrl;

  bool _isSyncing = false;
  int _pendingCount = 0;
  String? _lastError;

  bool get isSyncing => _isSyncing;
  int get pendingCount => _pendingCount;
  String? get lastError => _lastError;

  Future<void> refreshPendingCount() async {
    final count =
        await (database.selectOnly(database.coletas)
              ..addColumns([database.coletas.uuid.count()])
              ..where(
                database.coletas.statusSincronizacao.equalsValue(
                  StatusColeta.pendente,
                ),
              ))
            .getSingle();

    _pendingCount = count.read(database.coletas.uuid.count()) ?? 0;
    notifyListeners();
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _lastError = null;
    notifyListeners();

    try {
      final pendentes =
          await (database.select(database.coletas)..where(
                (c) => c.statusSincronizacao.equalsValue(StatusColeta.pendente),
              ))
              .get();

      log('Sincronizando ${pendentes.length} coletas...', name: 'SyncService');

      for (final coleta in pendentes) {
        await _syncColeta(coleta);
      }

      await refreshPendingCount();
    } catch (e) {
      _lastError = 'Falha na sincronização. Tente novamente.';
      log('Erro no syncAll', error: e, name: 'SyncService');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> _syncColeta(Coleta coleta) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/coletas'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uuid': coleta.uuid,
          'dados': coleta.dadosColetados,
          'versao': coleta.versao,
          'updated_at': coleta.updatedAt.toIso8601String(),
        }),
      );

      final novoStatus = switch (response.statusCode) {
        200 || 201 => StatusColeta.sincronizado,
        409 => StatusColeta.conflito,
        _ => null,
      };

      if (novoStatus != null) {
        await (database.update(
          database.coletas,
        )..where((c) => c.uuid.equals(coleta.uuid))).write(
          ColetasCompanion(
            statusSincronizacao: Value(novoStatus),
            versao: Value(coleta.versao + 1),
          ),
        );
      }
    } catch (e) {
      log(
        'Falha ao sincronizar coleta ${coleta.uuid}',
        error: e,
        name: 'SyncService',
      );
    }
  }
}
