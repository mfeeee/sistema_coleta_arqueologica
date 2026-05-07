import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import '../../domain/entities/coleta_entity.dart';
import '../models/coleta_model.dart';

abstract interface class ColetaApiDatasource {
  Future<List<ColetaEntity>> fetchMinhas({int page = 1});
}

class ColetaApiDatasourceImpl implements ColetaApiDatasource {
  ColetaApiDatasourceImpl({
    required this.httpClient,
    required this.secureStorage,
    required this.baseUrl,
  });

  final http.Client httpClient;
  final SecureStorageService secureStorage;
  final String baseUrl;

  @override
  Future<List<ColetaEntity>> fetchMinhas({int page = 1}) async {
    final token = await secureStorage.getJwt();
    if (token == null) return [];

    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/v1/mobile/coletas?page=$page'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        log(
          'fetchMinhas falhou: ${response.statusCode}',
          name: 'ColetaApiDatasource',
        );
        return [];
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>? ?? [];

      return data
          .map((e) => ColetaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Erro em fetchMinhas', error: e, name: 'ColetaApiDatasource');
      return [];
    }
  }
}
