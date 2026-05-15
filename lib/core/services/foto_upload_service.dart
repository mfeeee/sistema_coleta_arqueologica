import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class FotoUploadResult {
  final List<String> uploadedUrls;
  final List<String> failedPaths;
  const FotoUploadResult({
    required this.uploadedUrls,
    required this.failedPaths,
  });
}

class FotoUploadService {
  final Dio _dio;
  const FotoUploadService(this._dio);

  Future<FotoUploadResult> uploadFotos({
    required List<String> localPaths,
    required String token,
    void Function(int current, int total)? onProgress,
  }) async {
    final uploaded = <String>[];
    final failed = <String>[];

    for (var i = 0; i < localPaths.length; i++) {
      onProgress?.call(i + 1, localPaths.length);
      try {
        final file = File(localPaths[i]);
        if (!await file.exists()) {
          failed.add(localPaths[i]);
          continue;
        }

        final formData = FormData.fromMap({
          'fotos[]': await MultipartFile.fromFile(localPaths[i]),
        });

        final response = await _dio.post(
          '/v1/mobile/fotos',
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.statusCode == 201) {
          uploaded.addAll((response.data['urls'] as List).cast<String>());
        } else {
          failed.add(localPaths[i]);
        }
      } catch (e) {
        log('Upload falhou: $e', name: 'FotoUploadService');
        failed.add(localPaths[i]);
      }
    }
    return FotoUploadResult(uploadedUrls: uploaded, failedPaths: failed);
  }
}
