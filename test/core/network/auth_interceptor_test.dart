import 'package:checks/checks.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/network/interceptors/auth_interceptor.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';

class _FakeStorage extends Fake implements SecureStorageService {
  final String? token;
  _FakeStorage({this.token});
  @override
  Future<String?> getJwt() async => token;
}

class _CapturarRequestHandler extends RequestInterceptorHandler {
  RequestOptions? optionsCapturadas;
  @override
  void next(RequestOptions options) => optionsCapturadas = options;
}

class _CapturarErrorHandler extends ErrorInterceptorHandler {
  DioException? erroCapturado;
  @override
  void next(DioException err) => erroCapturado = err;
}

void main() {
  group('AuthInterceptor.onRequest', () {
    test('injeta Bearer token quando token existe', () async {
      final interceptor = AuthInterceptor(_FakeStorage(token: 'meu-token-jwt'));
      final options = RequestOptions(path: '/coletas');
      final handler = _CapturarRequestHandler();

      await interceptor.onRequest(options, handler);

      check(
        handler.optionsCapturadas!.headers['Authorization'],
      ).equals('Bearer meu-token-jwt');
    });

    test('não injeta Authorization quando token é null', () async {
      final interceptor = AuthInterceptor(_FakeStorage(token: null));
      final options = RequestOptions(path: '/coletas');
      final handler = _CapturarRequestHandler();

      await interceptor.onRequest(options, handler);

      check(
        handler.optionsCapturadas!.headers.containsKey('Authorization'),
      ).isFalse();
    });
  });

  group('AuthInterceptor.onError — 403', () {
    test('403 chama onSessionExpired', () async {
      bool sessionExpiredChamado = false;
      final interceptor = AuthInterceptor(
        _FakeStorage(token: 'token'),
        onSessionExpired: (_) => sessionExpiredChamado = true,
      );

      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
        ),
      );
      final handler = _CapturarErrorHandler();
      await interceptor.onError(err, handler);

      check(sessionExpiredChamado).isTrue();
    });
  });
}
