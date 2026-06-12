import 'dart:developer';
import 'package:sistema_coleta_arqueologica/core/services/foto_upload_service.dart';
import '../../coleta/domain/entities/coleta_entity.dart';
import '../domain/entities/sync_resumo.dart';
import 'sync_api_datasource.dart';

class ColetaSyncResultado {
  final SyncResultStatus status;
  final List<String> uploadedUrls;
  const ColetaSyncResultado({required this.status, required this.uploadedUrls});
}

class ColetaSyncStrategy {
  const ColetaSyncStrategy({
    required SyncApiDatasource apiDatasource,
    required FotoUploadService fotoUploadService,
  }) : _apiDatasource = apiDatasource,
       _fotoUploadService = fotoUploadService;

  final SyncApiDatasource _apiDatasource;
  final FotoUploadService _fotoUploadService;

  Future<ColetaSyncResultado> sincronizar(
    ColetaEntity coleta, {
    void Function(String mensagem)? onProgresso,
  }) async {
    final dadosOriginais = Map<String, dynamic>.from(coleta.dadosColetados);
    final fotoPaths =
        (dadosOriginais['foto_paths'] as List?)?.cast<String>() ?? [];

    var dadosFinais = dadosOriginais;
    final uploadedUrls = <String>[];

    if (fotoPaths.isNotEmpty) {
      final upload = await _fotoUploadService.uploadFotos(
        localPaths: fotoPaths,
        onProgress: (atual, total) =>
            onProgresso?.call('Enviando foto $atual/$total…'),
      );
      uploadedUrls.addAll(upload.uploadedUrls);
      if (upload.failedPaths.isNotEmpty) {
        log(
          'Fotos não enviadas para coleta ${coleta.id}: '
          '${upload.failedPaths}',
          name: 'ColetaSyncStrategy',
        );
      }
      dadosFinais = {
        ...dadosOriginais,
        'foto_urls': upload.uploadedUrls,
        'foto_paths': upload.failedPaths,
      };
    }

    final resultado = await _apiDatasource.enviarColeta(
      coleta: coleta,
      dadosColetadosOverride: dadosFinais,
      onTentativa: (t, max) => onProgresso?.call('Tentativa $t/$max…'),
    );

    return ColetaSyncResultado(
      status: resultado.status,
      uploadedUrls: uploadedUrls,
    );
  }
}
