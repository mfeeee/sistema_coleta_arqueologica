import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker;

  const MediaService(this._picker);

  Future<File?> pickAndCompress(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 100);

      if (picked == null) return null;

      final compressedPath = await compute(_compressIsolate, picked.path);

      if (compressedPath == null) return null;

      return File(compressedPath);
    } catch (e) {
      log('Falha em pickAndCompress', error: e, name: 'MediaService');
      return null;
    }
  }
}

Future<String?> _compressIsolate(String sourcePath) async {
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
    return null;
  }
}
