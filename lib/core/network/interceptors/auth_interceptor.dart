import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/errors/auth_exceptions.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final ValueChanged<String?>? onSessionExpired;
  final Future<bool> Function()? onRefreshToken;

  AuthInterceptor(
    this._secureStorage, {
    this.onSessionExpired,
    this.onRefreshToken,
  });

  bool _isRefreshing = false;
  final _failedRequests =
      <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getJwt();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && onRefreshToken != null) {
      if (_isRefreshing) {
        _failedRequests.add((options: err.requestOptions, handler: handler));
        return;
      }

      _isRefreshing = true;
      try {
        final refreshed = await onRefreshToken!();
        _isRefreshing = false;

        if (refreshed) {
          // Retry the current request
          final retryResponse = await _retry(err.requestOptions);
          handler.resolve(retryResponse);

          // Retry all queued requests
          for (final request in _failedRequests) {
            final response = await _retry(request.options);
            request.handler.resolve(response);
          }
          _failedRequests.clear();
          return;
        } else {
          _failedRequests.clear();
          onSessionExpired?.call(null);
        }
      } on AccountDeactivatedException catch (e) {
        _isRefreshing = false;
        _failedRequests.clear();
        onSessionExpired?.call(e.message);
      } catch (e) {
        _isRefreshing = false;
        _failedRequests.clear();
        onSessionExpired?.call(null);
      }
    }

    if (err.response?.statusCode == 403) {
      onSessionExpired?.call(null);
    }

    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await _secureStorage.getJwt();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return Dio(BaseOptions(baseUrl: requestOptions.baseUrl)).request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
