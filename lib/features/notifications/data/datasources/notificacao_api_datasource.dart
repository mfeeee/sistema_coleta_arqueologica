import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import '../models/notificacao_model.dart';

const _kTimeout = Duration(seconds: 15);

abstract interface class NotificacaoApiDatasource {
  Future<List<NotificacaoModel>> buscarNotificacoes();
  Future<void> marcarComoLida(int id);
}

List<NotificacaoModel> _parseNotificacoes(String corpo) {
  final decodificado = jsonDecode(corpo) as Map<String, dynamic>;
  final data = decodificado['data'] as List<dynamic>? ?? [];
  return data
      .map((e) => NotificacaoModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

class NotificacaoApiDatasourceImpl implements NotificacaoApiDatasource {
  const NotificacaoApiDatasourceImpl({
    required this.httpClient,
    required this.secureStorage,
    required this.baseUrl,
  });

  final http.Client httpClient;
  final SecureStorageService secureStorage;
  final String baseUrl;

  @override
  Future<List<NotificacaoModel>> buscarNotificacoes() async {
    final token = await secureStorage.getJwt();
    if (token == null) throw const ErroDeAutorizacao();

    try {
      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/v1/mobile/notificacoes'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_kTimeout);

      if (response.statusCode == 200) {
        return compute(_parseNotificacoes, response.body);
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
        'Erro HTTP em buscarNotificacoes',
        error: e,
        stackTrace: st,
        name: 'NotificacaoApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroComunicacao);
    } catch (e, st) {
      log(
        'Erro inesperado em buscarNotificacoes',
        error: e,
        stackTrace: st,
        name: 'NotificacaoApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroInesperado);
    }
  }

  @override
  Future<void> marcarComoLida(int id) async {
    final token = await secureStorage.getJwt();
    if (token == null) throw const ErroDeAutorizacao();

    try {
      final response = await httpClient
          .patch(
            Uri.parse('$baseUrl/v1/mobile/notificacoes/$id/lida'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_kTimeout);

      if (response.statusCode == 200 || response.statusCode == 204) return;
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const ErroDeAutorizacao();
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
        'Erro HTTP em marcarComoLida',
        error: e,
        stackTrace: st,
        name: 'NotificacaoApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroComunicacao);
    } catch (e, st) {
      log(
        'Erro inesperado em marcarComoLida',
        error: e,
        stackTrace: st,
        name: 'NotificacaoApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroInesperado);
    }
  }
}
