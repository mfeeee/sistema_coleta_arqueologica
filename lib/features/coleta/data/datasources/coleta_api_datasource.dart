import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import '../../domain/repositories/coleta_remota_repository.dart';
import '../models/coleta_model.dart';

const _kTimeoutRequisicao = Duration(seconds: 15);

abstract interface class ColetaApiDatasource implements ColetaRemotaRepository {
  @override
  Future<ColetaPage> fetchMinhas({int page = 1});
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
  Future<ColetaPage> fetchMinhas({int page = 1}) async {
    final token = await secureStorage.getJwt();
    if (token == null) throw const ErroDeAutorizacao();

    try {
      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/v1/mobile/coletas?page=$page'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_kTimeoutRequisicao);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? [];
        final total = body['total'] as int? ?? 0;
        final nextPageUrl = body['next_page_url'];
        return (
          items: data
              .map((e) => ColetaModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          total: total,
          temProxima: nextPageUrl != null,
        );
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
    } on TimeoutException catch (e) {
      log('Timeout em fetchMinhas', error: e, name: 'ColetaApiDatasource');
      throw const ErroDeRede(TratadorDeErros.erroComunicacao);
    } on http.ClientException catch (e, st) {
      log(
        'Erro HTTP em fetchMinhas',
        error: e,
        stackTrace: st,
        name: 'ColetaApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroComunicacao);
    } catch (e, st) {
      log(
        'Erro inesperado em fetchMinhas',
        error: e,
        stackTrace: st,
        name: 'ColetaApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroInesperado);
    }
  }
}
