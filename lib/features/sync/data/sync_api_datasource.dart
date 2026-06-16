import 'dart:developer';
import 'package:dio/dio.dart';
import '../../coleta/data/models/coleta_model.dart';
import '../../coleta/domain/entities/coleta_entity.dart';
import '../../../../core/utils/retry_util.dart';
import '../domain/entities/sync_resumo.dart';

class SyncResultado {
  final String coletaId;
  final SyncResultStatus status;
  final ColetaModel? coletaAtualizada;
  const SyncResultado({
    required this.coletaId,
    required this.status,
    this.coletaAtualizada,
  });
}

abstract class SyncApiDatasource {
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    Map<String, dynamic>? dadosColetadosOverride,
    void Function(int tentativa, int max)? onTentativa,
  });
}

class SyncApiDatasourceImpl implements SyncApiDatasource {
  final Dio _dio;

  const SyncApiDatasourceImpl(this._dio);

  @override
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    Map<String, dynamic>? dadosColetadosOverride,
    void Function(int tentativa, int max)? onTentativa,
  }) async {
    final model = ColetaModel.fromEntity(coleta);
    final coletaJson = model.toJson();

    // Se houver override de dados coletados (ex: fotos já processadas)
    if (dadosColetadosOverride != null) {
      coletaJson['dados_coletados'] = dadosColetadosOverride;
    }

    final payload = {
      'coletas': [coletaJson],
    };

    try {
      final response = await comRetry(
        maxTentativas: 3,
        delayInicial: const Duration(seconds: 1),
        onTentativa: onTentativa,
        operacao: () {
          log(
            'POST /v1/mobile/sync payload: $payload',
            name: 'SyncApiDatasource',
          );
          return _dio.post(
            '/v1/mobile/sync',
            data: payload,
            options: Options(
              sendTimeout: const Duration(seconds: 30),
              validateStatus: (status) => status != null && status < 500,
            ),
          );
        },
      );

      log(
        'POST /v1/mobile/sync → ${response.statusCode} | ${response.data}',
        name: 'SyncApiDatasource',
      );

      final statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 202) {
        ColetaModel? coletaAtualizada;
        try {
          final data = response.data;
          final json = (data is Map && data['data'] is Map)
              ? data['data'] as Map<String, dynamic>
              : data as Map<String, dynamic>;
          coletaAtualizada = ColetaModel.fromJson(json);
        } catch (e) {
          log(
            'Erro ao parsear resposta do sync: $e',
            name: 'SyncApiDatasource',
          );
        }
        return SyncResultado(
          coletaId: coleta.id,
          status: SyncResultStatus.sucesso,
          coletaAtualizada: coletaAtualizada,
        );
      }

      return SyncResultado(
        coletaId: coleta.id,
        status: statusCode == 409
            ? SyncResultStatus.conflito
            : SyncResultStatus.erroRede,
      );
    } on DioException catch (e) {
      log(
        'Erro de rede ao enviar coleta ${coleta.id} após tentativas: '
        '${e.message}',
        name: 'SyncApiDatasource',
      );
      return SyncResultado(
        coletaId: coleta.id,
        status: SyncResultStatus.erroRede,
      );
    }
  }
}
