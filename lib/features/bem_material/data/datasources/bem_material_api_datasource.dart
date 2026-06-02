import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import '../../domain/entities/bem_material_entity.dart';
import '../models/bem_material_model.dart';

const _kTimeout = Duration(seconds: 15);

abstract interface class BemMaterialApiDatasource {
  Future<List<BemMaterialEntity>> fetchBens({int page = 1});
}

class BemMaterialApiDatasourceImpl implements BemMaterialApiDatasource {
  BemMaterialApiDatasourceImpl({
    required this.httpClient,
    required this.secureStorage,
    required this.baseUrl,
  });

  final http.Client httpClient;
  final SecureStorageService secureStorage;
  final String baseUrl;

  @override
  Future<List<BemMaterialEntity>> fetchBens({int page = 1}) async {
    final token = await secureStorage.getJwt();
    if (token == null) throw const ErroDeAutorizacao();

    try {
      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/v1/mobile/bens-materiais?page=$page'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_kTimeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => BemMaterialModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const ErroDeAutorizacao();
      }

      if (response.statusCode >= 500) {
        throw ErroDeServidor('Erro do servidor: ${response.statusCode}');
      }

      throw ErroDeServidor('Resposta inesperada: ${response.statusCode}');
    } on ArqueoException {
      rethrow;
    } on SocketException {
      throw const ErroDeRede();
    } on TimeoutException {
      throw const ErroDeRede(TratadorDeErros.timeout);
    } on http.ClientException catch (e, st) {
      log(
        'Erro HTTP em fetchBens',
        error: e,
        stackTrace: st,
        name: 'BemMaterialApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroComunicacao);
    } catch (e, st) {
      log(
        'Erro inesperado em fetchBens',
        error: e,
        stackTrace: st,
        name: 'BemMaterialApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroInesperado);
    }
  }
}
