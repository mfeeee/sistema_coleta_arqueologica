import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/network/interceptors/auth_interceptor.dart';
import 'package:sistema_coleta_arqueologica/core/network/interceptors/error_interceptor.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';

class DioClient {
  static Dio authenticated({
    required String baseUrl,
    required SecureStorageService secureStorage,
    void Function(String?)? onSessionExpired,
    Future<bool> Function()? onRefreshToken,
  }) {
    final dio = _base(baseUrl);
    dio.interceptors.addAll([
      AuthInterceptor(
        secureStorage,
        onSessionExpired: onSessionExpired,
        onRefreshToken: onRefreshToken,
      ),
      ErrorInterceptor(),
    ]);
    return dio;
  }

  static Dio public({required String baseUrl}) {
    final dio = _base(baseUrl);
    dio.interceptors.add(ErrorInterceptor());
    return dio;
  }

  static Dio _base(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );
  }
}
