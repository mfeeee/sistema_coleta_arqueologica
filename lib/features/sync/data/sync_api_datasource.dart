import 'dart:developer';
import 'package:dio/dio.dart';
import '../../coleta/domain/entities/coleta_entity.dart';

enum SyncResultStatus { sucesso, erroRede, conflito }

class SyncResultado {
  final String coletaId;
  final SyncResultStatus status;
  const SyncResultado({required this.coletaId, required this.status});
}

abstract class SyncApiDatasource {
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    required String bearerToken,
  });
}

class SyncApiDatasourceImpl implements SyncApiDatasource {
  final Dio _dio;

  const SyncApiDatasourceImpl(this._dio);

  @override
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    required String bearerToken,
  }) async {
    try {
      final payload = {
        'coletas': [
          {
            'id': coleta.id,
            'data_coleta': coleta.dataColeta.toUtc().toIso8601String(),
            'nome_bem': coleta.nomeBem,
            'latitude': coleta.latitude,
            'longitude': coleta.longitude,
            'natureza': coleta.natureza?.name,
            'tipo': coleta.tipo?.name,
            'uf': coleta.uf,
            'artefatos': coleta.artefatos.map((e) => e.name).toList(),
            'versao': coleta.versao,
            'dados_coletados': coleta.dadosColetados,
          },
        ],
      };

      log('POST /v1/mobile/sync payload: $payload', name: 'SyncApiDatasource');

      final response = await _dio.post(
        '/v1/mobile/sync',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log(
        'POST /v1/mobile/sync → ${response.statusCode} | ${response.data}',
        name: 'SyncApiDatasource',
      );

      return SyncResultado(
        coletaId: coleta.id,
        status: switch (response.statusCode) {
          200 || 202 => SyncResultStatus.sucesso,
          409 => SyncResultStatus.conflito,
          _ => SyncResultStatus.erroRede,
        },
      );
    } on DioException catch (e) {
      log(
        'Erro de rede ao enviar coleta ${coleta.id}: ${e.message}',
        name: 'SyncApiDatasource',
      );
      return SyncResultado(
        coletaId: coleta.id,
        status: SyncResultStatus.erroRede,
      );
    }
  }
}
