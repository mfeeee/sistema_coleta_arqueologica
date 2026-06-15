import 'package:checks/checks.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import 'package:sistema_coleta_arqueologica/core/network/interceptors/error_interceptor.dart';

DioException _dioErro(DioExceptionType tipo, {int? statusCode}) {
  return DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: tipo,
    response: statusCode != null
        ? Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: statusCode,
          )
        : null,
  );
}

class _CapturarHandler extends ErrorInterceptorHandler {
  DioException? erroCapturado;
  @override
  void next(DioException err) => erroCapturado = err;
}

void main() {
  late ErrorInterceptor interceptor;

  setUp(() => interceptor = ErrorInterceptor());

  group('ErrorInterceptor — mapeamento de erros', () {
    test('connectionTimeout → ErroDeRede', () {
      final handler = _CapturarHandler();
      interceptor.onError(
        _dioErro(DioExceptionType.connectionTimeout),
        handler,
      );
      check(handler.erroCapturado!.error).isA<ErroDeRede>();
    });

    test('sendTimeout → ErroDeRede', () {
      final handler = _CapturarHandler();
      interceptor.onError(_dioErro(DioExceptionType.sendTimeout), handler);
      check(handler.erroCapturado!.error).isA<ErroDeRede>();
    });

    test('connectionError → ErroDeRede', () {
      final handler = _CapturarHandler();
      interceptor.onError(_dioErro(DioExceptionType.connectionError), handler);
      check(handler.erroCapturado!.error).isA<ErroDeRede>();
    });

    test('401 → ErroDeAutorizacao', () {
      final handler = _CapturarHandler();
      interceptor.onError(
        _dioErro(DioExceptionType.badResponse, statusCode: 401),
        handler,
      );
      check(handler.erroCapturado!.error).isA<ErroDeAutorizacao>();
    });

    test('403 → ErroDeAutorizacao', () {
      final handler = _CapturarHandler();
      interceptor.onError(
        _dioErro(DioExceptionType.badResponse, statusCode: 403),
        handler,
      );
      check(handler.erroCapturado!.error).isA<ErroDeAutorizacao>();
    });

    test('422 → ErroDeValidacao', () {
      final handler = _CapturarHandler();
      interceptor.onError(
        _dioErro(DioExceptionType.badResponse, statusCode: 422),
        handler,
      );
      check(handler.erroCapturado!.error).isA<ErroDeValidacao>();
    });

    test('500 → ErroDeServidor', () {
      final handler = _CapturarHandler();
      interceptor.onError(
        _dioErro(DioExceptionType.badResponse, statusCode: 500),
        handler,
      );
      check(handler.erroCapturado!.error).isA<ErroDeServidor>();
    });

    test('erro desconhecido → ErroDeServidor', () {
      final handler = _CapturarHandler();
      interceptor.onError(_dioErro(DioExceptionType.unknown), handler);
      check(handler.erroCapturado!.error).isA<ErroDeServidor>();
    });
  });
}
