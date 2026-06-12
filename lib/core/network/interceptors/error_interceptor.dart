import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final arqueoException = _mapToArqueoException(err);
    handler.next(err.copyWith(error: arqueoException));
  }

  ArqueoException _mapToArqueoException(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return const ErroDeRede();
    }

    if (err.error is SocketException) {
      return const ErroDeRede();
    }

    if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;

      if (statusCode == 401 || statusCode == 403) {
        return const ErroDeAutorizacao();
      }

      if (statusCode == 422) {
        return const ErroDeValidacao();
      }

      if (statusCode != null && statusCode >= 500) {
        return ErroDeServidor('Erro do servidor: $statusCode');
      }
    }

    return ErroDeServidor('Erro inesperado: ${err.message}');
  }
}
