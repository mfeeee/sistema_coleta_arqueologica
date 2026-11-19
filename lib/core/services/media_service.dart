import 'dart:developer';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker;

  const MediaService(this._picker);

  Future<File?> pickAndCompress(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 100);

      if (picked == null) return null;

      // Sem compute(): o plugin de compressão usa canal nativo, que não existe
      // em isolate secundário (falhava em silêncio e a foto sumia). A
      // compressão já roda fora da thread de UI, no lado nativo.
      final compressedPath = await _comprimir(picked.path);

      if (compressedPath == null) return null;

      return File(compressedPath);
    } catch (e) {
      log('Falha em pickAndCompress', error: e, name: 'MediaService');
      return null;
    }
  }
}

Future<String?> _comprimir(String sourcePath) async {
  if (!File(sourcePath).existsSync()) {
    return null;
  }

  try {
    final targetPath = '${sourcePath}_c.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: 75,
      minWidth: 1280,
      minHeight: 720,
      format: CompressFormat.jpeg,
    );

    return result?.path;
  } catch (e) {
    log('Falha ao comprimir foto', error: e, name: 'MediaService');
    return null;
  }
}
