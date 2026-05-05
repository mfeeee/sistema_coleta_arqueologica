import 'package:dio/dio.dart';

class DioClient {
  static Dio create({required String baseUrl, required String bearerToken}) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      ),
    );
  }
}
