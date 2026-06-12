import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import '../models/preferencias_notificacao.dart';

abstract interface class PreferenciasApiDatasource {
  Future<PreferenciasNotificacao> buscar();
  Future<void> salvar(PreferenciasNotificacao prefs);
}

class PreferenciasApiDatasourceImpl implements PreferenciasApiDatasource {
  const PreferenciasApiDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<PreferenciasNotificacao> buscar() async {
    try {
      final response = await dio.get('/v1/mobile/preferencias');

      final body = response.data as Map<String, dynamic>;
      final data = (body['data'] ?? body) as Map<String, dynamic>;
      return PreferenciasNotificacao.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const PreferenciasNotificacao();
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }

  @override
  Future<void> salvar(PreferenciasNotificacao prefs) async {
    try {
      await dio.put('/v1/mobile/preferencias', data: prefs.toJson());
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }
}
