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
        log(
          'fetchBens p$page — body(500): ${response.body.substring(0, response.body.length.clamp(0, 500))}',
          name: 'BemMaterialApiDatasource',
        );
        final decoded = jsonDecode(response.body);
        final data = _extrairLista(decoded);
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) {
              try {
                return BemMaterialModel.fromJson(e);
              } catch (err, st) {
                log(
                  'fromJson falhou — id: ${e['id']} — $err',
                  name: 'BemMaterialApiDatasource',
                  error: err,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<BemMaterialModel>()
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

  /// Extrai a lista de bens de qualquer formato de envelope que a API retorne.
  ///
  /// Suporta:
  ///   - `[{...}]`                           → resposta direta como lista
  ///   - `{"data": [{...}]}`                 → envelope simples
  ///   - `{"data": {"data": [{...}], ...}}`  → Laravel paginate com wrapper
  ///   - `{"data": "[{...}]"}`               → JSON double-encoded
  static List<dynamic> _extrairLista(dynamic decoded) {
    if (decoded is List) return decoded;

    if (decoded is Map<String, dynamic>) {
      final raw = decoded['data'];

      if (raw is List) return raw;

      if (raw is Map<String, dynamic>) {
        final inner = raw['data'];
        if (inner is List) return inner;
      }

      if (raw is String) {
        final inner = jsonDecode(raw);
        if (inner is List) return inner;
      }

      log(
        'fetchBens — estrutura inesperada em data: ${raw?.runtimeType}',
        name: 'BemMaterialApiDatasource',
      );
    }

    return [];
  }
}
