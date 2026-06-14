import 'dart:developer';
import '../../../core/database/enums/status_coleta.dart';
import '../../coleta/data/datasources/coleta_local_datasource.dart';
import '../domain/entities/sync_resumo.dart';
import 'coleta_sync_strategy.dart';

class SyncRepository {
  const SyncRepository({
    required ColetaLocalDatasource coletaDatasource,
    required ColetaSyncStrategy strategy,
  }) : _coletaDatasource = coletaDatasource,
       _strategy = strategy;

  final ColetaLocalDatasource _coletaDatasource;
  final ColetaSyncStrategy _strategy;

  Future<int> contarPendentes() async {
    final pendentes = await _coletaDatasource.getPendentes();
    return pendentes.length;
  }

  Future<SyncResumo> sincronizarTodas({
    void Function(String mensagem)? onProgresso,
  }) async {
    final pendentes = await _coletaDatasource.getPendentes();
    if (pendentes.isEmpty) {
      return const SyncResumo(sucessos: 0, conflitos: 0, erros: 0);
    }
    log(
      'Iniciando sync de ${pendentes.length} coleta(s).',
      name: 'SyncRepository',
    );
    int sucessos = 0, conflitos = 0, erros = 0;
    for (var i = 0; i < pendentes.length; i++) {
      final coleta = pendentes[i];
      onProgresso?.call('Sincronizando coleta ${i + 1}/${pendentes.length}…');
      final res = await _strategy.sincronizar(coleta, onProgresso: onProgresso);

      // Sync ≠ aprovação: dados transmitidos, servidor pode sobrescrever.
      switch (res.status) {
        case SyncResultStatus.sucesso:
          await _coletaDatasource.atualizarStatus(
            coleta.id,
            StatusColeta.sincronizado,
            coleta.versao,
          );
          sucessos++;
        case SyncResultStatus.conflito:
          await _coletaDatasource.atualizarStatus(
            coleta.id,
            StatusColeta.conflito,
            coleta.versao + 1,
          );
          conflitos++;
        case SyncResultStatus.erroRede:
          erros++;
      }
    }
    log(
      'Sync concluído — ✓$sucessos ✗$conflitos ~$erros',
      name: 'SyncRepository',
    );
    return SyncResumo(sucessos: sucessos, conflitos: conflitos, erros: erros);
  }
}
