import 'dart:developer';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'secure_storage_service.dart';
import 'dart:async';

class AuthenticatedHttpClient extends http.BaseClient {
  AuthenticatedHttpClient({
    required this.secureStorage,
    required this.authService,
    http.Client? inner,
  }) : _inner = inner ?? http.Client();

  final SecureStorageService secureStorage;
  final AuthService authService;
  final http.Client _inner;

  Completer<bool>? _refreshCompleter;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await secureStorage.getJwt();

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401) return response;

    log('JWT expirado, tentando refresh...', name: 'AuthenticatedHttpClient');

    final refreshed = await _getOrAwaitRefresh();

    if (!refreshed) {
      log('Refresh falhou. Sessão encerrada.', name: 'AuthenticatedHttpClient');
      return response;
    }

    final newToken = await secureStorage.getJwt();
    final retryRequest = _cloneRequest(request, newToken);
    return _inner.send(retryRequest);
  }

  Future<bool> _getOrAwaitRefresh() async {
    if (_refreshCompleter != null) {
      log(
        'Aguardando refresh em andamento...',
        name: 'AuthenticatedHttpClient',
      );
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final result = await authService.refreshToken();
      _refreshCompleter!.complete(result);
      return result;
    } catch (e) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  http.BaseRequest _cloneRequest(http.BaseRequest original, String? newToken) {
    final cloned = http.Request(original.method, original.url);

    cloned.headers.addAll(original.headers);
    if (newToken != null) {
      cloned.headers['Authorization'] = 'Bearer $newToken';
    }

    if (original is http.Request) {
      cloned.body = original.body;
    }

    return cloned;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
