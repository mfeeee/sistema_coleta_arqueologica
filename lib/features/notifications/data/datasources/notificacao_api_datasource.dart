import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import '../models/notificacao_model.dart';

abstract interface class NotificacaoApiDatasource {
  Future<List<NotificacaoModel>> buscarNotificacoes();
  Future<void> marcarComoLida(int id);
}

class NotificacaoApiDatasourceImpl implements NotificacaoApiDatasource {
  const NotificacaoApiDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<NotificacaoModel>> buscarNotificacoes() async {
    try {
      final response = await dio.get('/v1/mobile/notificacoes');

      final decodificado = response.data as Map<String, dynamic>;
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
  Future<void> marcarComoLida(int id) async {
    try {
      await dio.patch('/v1/mobile/notificacoes/$id/lida');
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }
}
