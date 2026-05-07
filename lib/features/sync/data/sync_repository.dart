import 'dart:developer';
import '../../../core/database/enums/status_coleta.dart';
import '../../coleta/data/datasources/coleta_local_datasource.dart';
import '../../coleta/domain/entities/coleta_entity.dart';
import 'sync_api_datasource.dart';

class SyncRepository {
  final ColetaLocalDatasource _coletaDatasource;
  final SyncApiDatasource _apiDatasource;

  const SyncRepository({
    required ColetaLocalDatasource coletaDatasource,
    required SyncApiDatasource apiDatasource,
  }) : _coletaDatasource = coletaDatasource,
       _apiDatasource = apiDatasource;

  Future<int> contarPendentes() async {
    final pendentes = await _coletaDatasource.getPendentes();
    return pendentes.length;
  }

  Future<SyncResumo> sincronizarTodas(String bearerToken) async {
    final pendentes = await _coletaDatasource.getPendentes();

    if (pendentes.isEmpty) {
      return const SyncResumo(sucessos: 0, conflitos: 0, erros: 0);
    }

    log(
      'Iniciando sync de ${pendentes.length} coleta(s).',
      name: 'SyncRepository',
    );

    int sucessos = 0, conflitos = 0, erros = 0;

    for (final coleta in pendentes) {
      final resultado = await _sincronizarUma(coleta, bearerToken);

      switch (resultado) {
        case SyncResultStatus.sucesso:
          sucessos++;
        case SyncResultStatus.conflito:
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

  Future<SyncResultStatus> _sincronizarUma(
    ColetaEntity coleta,
    String bearerToken,
  ) async {
    final resultado = await _apiDatasource.enviarColeta(
      coleta: coleta,
      bearerToken: bearerToken,
    );

    switch (resultado.status) {
      case SyncResultStatus.sucesso:
        await _coletaDatasource.atualizarStatus(
          coleta.id,
          StatusColeta.sincronizado,
          coleta.versao + 1,
        );

      case SyncResultStatus.conflito:
        await _coletaDatasource.atualizarStatus(
          coleta.id,
          StatusColeta.conflito,
          coleta.versao + 1,
        );

      case SyncResultStatus.erroRede:
        break;
    }

    return resultado.status;
  }
}

class SyncResumo {
  final int sucessos;
  final int conflitos;
  final int erros;

  const SyncResumo({
    required this.sucessos,
    required this.conflitos,
    required this.erros,
  });

  bool get totalOk => conflitos == 0 && erros == 0;
  int get total => sucessos + conflitos + erros;
}
