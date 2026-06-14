import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/models/midia_model.dart';

abstract class MidiaRemoteDatasource {
  Future<MidiaModel> uploadMidia({
    required File file,
    required String mediableType,
    required String mediableId,
    required String tipo,
    String? descricao,
  });
}

class MidiaRemoteDatasourceImpl implements MidiaRemoteDatasource {
  final Dio dio;

  MidiaRemoteDatasourceImpl({required this.dio});

  @override
  Future<MidiaModel> uploadMidia({
    required File file,
    required String mediableType,
    required String mediableId,
    required String tipo,
    String? descricao,
  }) async {
    final bytes = await compute(_readFileBytes, file.path);
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
      'mediable_type': mediableType,
      'mediable_id': mediableId,
      'tipo': tipo,
      if (descricao != null) 'descricao': descricao,
    });

    final response = await dio.post('/midias', data: formData);

    return MidiaModel.fromJson(response.data as Map<String, dynamic>);
  }
}

List<int> _readFileBytes(String path) {
  return File(path).readAsBytesSync();
}
