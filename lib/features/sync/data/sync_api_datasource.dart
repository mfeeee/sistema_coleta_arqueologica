import 'dart:developer';
import 'package:dio/dio.dart';
import '../../coleta/domain/entities/coleta_entity.dart';
import '../../bem_material/domain/entities/bem_material_entity.dart';

enum SyncResultStatus { sucesso, erroRede, conflito }

class SyncResultado {
  final String coletaId;
  final SyncResultStatus status;
  const SyncResultado({required this.coletaId, required this.status});
}

abstract class SyncApiDatasource {
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    required BemMaterialEntity bemMaterial,
    required String bearerToken,
  });
}

class SyncApiDatasourceImpl implements SyncApiDatasource {
  final Dio _dio;

  const SyncApiDatasourceImpl(this._dio);

  @override
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    required BemMaterialEntity bemMaterial,
    required String bearerToken,
  }) async {
    try {
      final formData = await _buildFormData(coleta, bemMaterial);

      final response = await _dio.post(
        '/coletas',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $bearerToken'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log(
        'POST /coletas → ${response.statusCode} (coleta: ${coleta.id})',
        name: 'SyncApiDatasource',
      );

      return SyncResultado(
        coletaId: coleta.id,
        status: switch (response.statusCode) {
          200 || 202 => SyncResultStatus.sucesso,
          409 => SyncResultStatus.conflito,
          _ => SyncResultStatus.erroRede,
        },
      );
    } on DioException catch (e) {
      log(
        'Erro de rede ao enviar coleta ${coleta.id}: ${e.message}',
        name: 'SyncApiDatasource',
      );
      return SyncResultado(
        coletaId: coleta.id,
        status: SyncResultStatus.erroRede,
      );
    }
  }

  Future<FormData> _buildFormData(
    ColetaEntity coleta,
    BemMaterialEntity bemMaterial,
  ) async {
    final Map<String, dynamic> fields = {
      // Coleta
      'uuid': coleta.id,
      'usuario_id': coleta.usuarioId,
      'data_coleta': coleta.dataColeta.toIso8601String(),
      'nome_bem': coleta.nomeBem,
      'natureza': coleta.natureza?.name,
      'tipo': coleta.tipo?.name,
      'uf': coleta.uf,
      'latitude': coleta.latitude,
      'longitude': coleta.longitude,
      'artefatos': coleta.artefatos.map((e) => e.name).toList(),
      'versao': coleta.versao,
      // Bem Material
      'bem_codigo_iphan': bemMaterial.codigoIphan,
      'bem_municipio': bemMaterial.municipio,
      'bem_cep': bemMaterial.cep,
      'bem_endereco': bemMaterial.endereco,
      'bem_meios_acesso': bemMaterial.meiosAcesso,
      'bem_nomes_populares': bemMaterial.nomesPopulares.join(','),
    };

    fields.removeWhere((_, v) => v == null);

    final formData = FormData.fromMap(fields);

    final fotoPaths = coleta.dadosColetados['foto_paths'];
    if (fotoPaths is List) {
      for (int i = 0; i < fotoPaths.length; i++) {
        final path = fotoPaths[i] as String?;
        if (path != null && path.isNotEmpty) {
          formData.files.add(
            MapEntry(
              'fotos[$i]',
              await MultipartFile.fromFile(
                path,
                filename: 'foto_${coleta.id}_$i.jpg',
              ),
            ),
          );
        }
      }
    }

    final audioPath = coleta.dadosColetados['audio_path'] as String?;
    if (audioPath != null && audioPath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'audio',
          await MultipartFile.fromFile(
            audioPath,
            filename: 'audio_${coleta.id}.m4a',
          ),
        ),
      );
    }

    return formData;
  }
}
