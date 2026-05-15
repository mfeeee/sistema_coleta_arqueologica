import 'dart:developer';
import '../../../core/database/enums/status_coleta.dart';
import '../../../core/services/foto_upload_service.dart';
import '../../coleta/data/datasources/coleta_local_datasource.dart';
import '../../coleta/domain/entities/coleta_entity.dart';
import 'sync_api_datasource.dart';

class SyncRepository {
  final ColetaLocalDatasource _coletaDatasource;
  final SyncApiDatasource _apiDatasource;
  final FotoUploadService _fotoUploadService;

  const SyncRepository({
    required ColetaLocalDatasource coletaDatasource,
    required SyncApiDatasource apiDatasource,
    required FotoUploadService fotoUploadService,
  }) : _coletaDatasource = coletaDatasource,
       _apiDatasource = apiDatasource,
       _fotoUploadService = fotoUploadService;

  Future<int> contarPendentes() async {
    final pendentes = await _coletaDatasource.getPendentes();
    return pendentes.length;
  }

  Future<SyncResumo> sincronizarTodas(
    String bearerToken, {
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

      final resultado = await _sincronizarUma(
        coleta,
        bearerToken,
        onProgresso: onProgresso,
      );

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
    String bearerToken, {
    void Function(String mensagem)? onProgresso,
  }) async {
    final dadosOriginais = Map<String, dynamic>.from(coleta.dadosColetados);
    final fotoPaths =
        (dadosOriginais['foto_paths'] as List?)?.cast<String>() ?? [];

    Map<String, dynamic> dadosFinais = dadosOriginais;

    if (fotoPaths.isNotEmpty) {
      final uploadResult = await _fotoUploadService.uploadFotos(
        localPaths: fotoPaths,
        token: bearerToken,
        onProgress: (atual, total) =>
            onProgresso?.call('Enviando foto $atual/$total…'),
      );

      if (uploadResult.failedPaths.isNotEmpty) {
        log(
          'Fotos não enviadas para coleta ${coleta.id}: '
          '${uploadResult.failedPaths}',
          name: 'SyncRepository',
        );
      }

      dadosFinais = {
        ...dadosOriginais,
        'foto_urls': uploadResult.uploadedUrls,
        'foto_paths': uploadResult.failedPaths,
      };
    }

    final resultado = await _apiDatasource.enviarColeta(
      coleta: coleta,
      bearerToken: bearerToken,
      dadosColetadosOverride: dadosFinais,
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
