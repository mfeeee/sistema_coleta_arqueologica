import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../coleta/data/models/coleta_model.dart';
import '../../coleta/domain/entities/coleta_entity.dart';
import '../../../../core/utils/retry_util.dart';
import '../domain/entities/sync_resumo.dart';

class SyncResultado {
  final String coletaId;
  final SyncResultStatus status;
  final ColetaModel? coletaAtualizada;

  /// Motivo devolvido pela API quando a coleta é recusada (403 ou 422).
  final String? mensagem;

  const SyncResultado({
    required this.coletaId,
    required this.status,
    this.coletaAtualizada,
    this.mensagem,
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
          // O payload tem coordenadas e dados do coletor: só em depuração.
          if (kDebugMode) {
            log(
              'POST /v1/mobile/sync payload: $payload',
              name: 'SyncApiDatasource',
            );
          }
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

      // 403 (coleta de outra pessoa) e 422 (dado inválido) não mudam com
      // nova tentativa: a coleta precisa ser corrigida antes de reenviar.
      if (statusCode == 403 || statusCode == 422) {
        return SyncResultado(
          coletaId: coleta.id,
          status: SyncResultStatus.recusada,
          mensagem: _mensagemDaApi(response.data),
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

String? _mensagemDaApi(Object? data) {
  if (data is! Map) return null;
  // No 422 de validação, `message` é só "Erro de validação."; o motivo útil
  // (ex.: "O campo CEP não deve ter mais de 9 caracteres.") vem em `errors`.
  final erros = data['errors'];
  if (erros is Map) {
    for (final lista in erros.values) {
      if (lista is List && lista.isNotEmpty && lista.first is String) {
        return lista.first as String;
      }
    }
  }
  final mensagem = data['message'];
  return mensagem is String ? mensagem : null;
}
