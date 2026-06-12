import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import '../../domain/entities/bem_material_entity.dart';
import '../models/bem_material_model.dart';

abstract interface class BemMaterialApiDatasource {
  Future<List<BemMaterialEntity>> fetchBens({int page = 1});
}

class BemMaterialApiDatasourceImpl implements BemMaterialApiDatasource {
  BemMaterialApiDatasourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<BemMaterialEntity>> fetchBens({int page = 1}) async {
    try {
      final response = await dio.get(
        '/v1/mobile/bens-materiais',
        queryParameters: {'page': page},
      );

      final decoded = response.data;
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
    } on DioException catch (e) {
      if (e.error is ArqueoException) {
        throw e.error as ArqueoException;
      }
      rethrow;
    }
  }

  /// Extrai a lista de bens de qualquer formato de envelope que a API retorne.
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
        // Dio might have already decoded it if it's JSON, but just in case
        return [];
      }

      log(
        'fetchBens — estrutura inesperada em data: ${raw?.runtimeType}',
        name: 'BemMaterialApiDatasource',
      );
    }

    return [];
  }
}
