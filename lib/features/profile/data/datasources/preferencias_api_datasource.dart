import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import '../models/preferencias_notificacao.dart';

const _kTimeout = Duration(seconds: 15);

abstract interface class PreferenciasApiDatasource {
  Future<PreferenciasNotificacao> buscar();
  Future<void> salvar(PreferenciasNotificacao prefs);
}

class PreferenciasApiDatasourceImpl implements PreferenciasApiDatasource {
  const PreferenciasApiDatasourceImpl({
    required this.httpClient,
    required this.secureStorage,
    required this.baseUrl,
  });

  final http.Client httpClient;
  final SecureStorageService secureStorage;
  final String baseUrl;

  Future<Map<String, String>> _cabecalhos() async {
    final token = await secureStorage.getJwt();
    if (token == null) throw const ErroDeAutorizacao();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  @override
  Future<PreferenciasNotificacao> buscar() async {
    try {
      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/v1/mobile/preferencias'),
            headers: await _cabecalhos(),
          )
          .timeout(_kTimeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = (body['data'] ?? body) as Map<String, dynamic>;
        return PreferenciasNotificacao.fromJson(data);
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const ErroDeAutorizacao();
      }
      if (response.statusCode == 404) return const PreferenciasNotificacao();
      throw ErroDeServidor('Resposta inesperada: ${response.statusCode}');
    } on ArqueoException {
      rethrow;
    } on SocketException {
      throw const ErroDeRede();
    } on TimeoutException {
      throw const ErroDeRede(TratadorDeErros.timeout);
    } on http.ClientException catch (e, st) {
      log(
        'Erro HTTP ao buscar preferências',
        error: e,
        stackTrace: st,
        name: 'PreferenciasApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroComunicacao);
    }
  }

  @override
  Future<void> salvar(PreferenciasNotificacao prefs) async {
    try {
      final headers = await _cabecalhos();
      final response = await httpClient
          .put(
            Uri.parse('$baseUrl/v1/mobile/preferencias'),
            headers: {...headers, 'Content-Type': 'application/json'},
            body: jsonEncode(prefs.toJson()),
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
        'Erro HTTP ao salvar preferências',
        error: e,
        stackTrace: st,
        name: 'PreferenciasApiDatasource',
      );
      throw const ErroDeRede(TratadorDeErros.erroComunicacao);
    }
  }
}
