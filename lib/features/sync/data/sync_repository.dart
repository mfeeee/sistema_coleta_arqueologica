import 'dart:developer';
import 'package:sistema_coleta_arqueologica/core/models/midia_model.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';

import '../../../core/database/enums/status_coleta.dart';
import '../../coleta/data/datasources/coleta_api_datasource.dart';
import '../../coleta/data/datasources/coleta_local_datasource.dart';
import '../domain/entities/sync_resumo.dart';
import 'coleta_sync_strategy.dart';

class SyncRepository {
  const SyncRepository({
    required ColetaLocalDatasource coletaDatasource,
    required ColetaSyncStrategy strategy,
    required ColetaApiDatasource coletaApiDatasource,
  }) : _coletaDatasource = coletaDatasource,
       _strategy = strategy,
       _coletaApiDatasource = coletaApiDatasource;

  final ColetaLocalDatasource _coletaDatasource;
  final ColetaSyncStrategy _strategy;
  final ColetaApiDatasource _coletaApiDatasource;

  Future<int> contarPendentes() async {
    final pendentes = await _coletaDatasource.getPendentes();
    return pendentes.length;
  }

  Future<void> puxarDoServidor() async {
    int page = 1;
    bool temProxima = true;

    while (temProxima) {
      final resultado = await _coletaApiDatasource.fetchMinhas(page: page);

      for (final item in resultado.items) {
        // Normaliza mediableType das mídias: 'App\Models\Coleta' → 'coleta'
        final midiasNormalizadas = item.midias.map((m) {
          final tipo = m.mediableType.split('\\').last.toLowerCase();
          return MidiaModel(
            id: m.id,
            mediableType: tipo,
            mediableId: m.mediableId,
            storagePath: m.storagePath,
            mimeType: m.mimeType,
            tipo: m.tipo,
            url: m.url,
            descricao: m.descricao,
          );
        }).toList();

        final coletaNormalizada = ColetaModel(
          id: item.id,
          usuarioId: item.usuarioId,
          dataColeta: item.dataColeta,
          syncStatus: item.syncStatus,
          nomeBem: item.nomeBem,
          localizacao: item.localizacao,
          artefatoTipos: item.artefatoTipos,
          versao: item.versao,
          updatedAt: item.updatedAt,
          dadosColetados: item.dadosColetados,
          midias: midiasNormalizadas,
          natureza: item.natureza,
          tipo: item.tipo,
          uf: item.uf,
          deletadoEm: item.deletadoEm,
        );

        await _coletaDatasource.inserir(coletaNormalizada);
      }

      temProxima = resultado.temProxima;
      page++;
    }

    log('Pull concluído — página(s): ${page - 1}', name: 'SyncRepository');
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

      switch (res.status) {
        case SyncResultStatus.sucesso:
          if (res.coletaAtualizada != null) {
            await _coletaDatasource.inserir(res.coletaAtualizada!);
          } else {
            await _coletaDatasource.atualizarStatus(
              coleta.id,
              StatusColeta.sincronizado,
              coleta.versao,
            );
          }
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
