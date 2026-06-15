import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import '../models/notificacao_model.dart';

abstract interface class NotificacaoApiDatasource {
  Future<List<NotificacaoModel>> listar();
  Future<void> marcarComoLida(String id);
  Future<PreferenciasNotificacaoModel> getPreferencias();
  Future<void> atualizarPreferencias(PreferenciasNotificacaoModel preferencias);
}

class NotificacaoApiDatasourceImpl implements NotificacaoApiDatasource {
  const NotificacaoApiDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<NotificacaoModel>> listar() async {
    try {
      final response = await dio.get('/v1/mobile/notificacoes');

      final decodificado = response.data as Map<String, dynamic>;
      // A API pode retornar os dados em 'data' se for paginado
      final data = decodificado['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => NotificacaoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }

  @override
  Future<void> marcarComoLida(String id) async {
    try {
      await dio.post('/v1/mobile/notificacoes/$id/ler');
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }

  @override
  Future<PreferenciasNotificacaoModel> getPreferencias() async {
    try {
      final response = await dio.get('/v1/mobile/preferencias-notificacoes');
      return PreferenciasNotificacaoModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }

  @override
  Future<void> atualizarPreferencias(
    PreferenciasNotificacaoModel preferencias,
  ) async {
    try {
      await dio.put(
        '/v1/mobile/preferencias-notificacoes',
        data: preferencias.toJson(),
      );
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }
}
