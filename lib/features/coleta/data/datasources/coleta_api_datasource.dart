import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import '../../domain/repositories/coleta_remota_repository.dart';
import '../models/coleta_model.dart';

abstract interface class ColetaApiDatasource implements ColetaRemotaRepository {
  @override
  Future<ColetaPage> fetchMinhas({int page = 1});
}

class ColetaApiDatasourceImpl implements ColetaApiDatasource {
  ColetaApiDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<ColetaPage> fetchMinhas({int page = 1}) async {
    try {
      final response = await dio.get(
        '/v1/mobile/coletas',
        queryParameters: {'page': page},
      );

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>? ?? [];
      final total = body['total'] as int? ?? 0;
      final nextPageUrl = body['next_page_url'];

      return (
        items: data
            .map((e) => ColetaModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: total,
        temProxima: nextPageUrl != null,
      );
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }
}
