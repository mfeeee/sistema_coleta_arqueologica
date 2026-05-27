import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract interface class DraftPhotoStorage {
  Future<List<String>> persistir(List<File> files);
  List<File> restaurar(List<String> paths);
}

class DraftPhotoStorageImpl implements DraftPhotoStorage {
  const DraftPhotoStorageImpl();

  static const String _prefixo = 'draft_photo_';

  @override
  Future<List<String>> persistir(List<File> files) async {
    if (files.isEmpty) return [];
    final dir = await getApplicationDocumentsDirectory();
    final paths = <String>[];
    for (final file in files) {
      final destPath = _buildDestPath(dir.path, file.path);
      await _copiarSeNecessario(file, destPath);
      paths.add(destPath);
    }
    log('${paths.length} fotos persistidas', name: 'DraftPhotoStorage');
    return paths;
  }

  @override
  List<File> restaurar(List<String> paths) {
    final files = <File>[];
    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) {
        files.add(file);
        log('Foto restaurada: $path', name: 'DraftPhotoStorage');
      } else {
        log('Foto ausente, ignorando: $path', name: 'DraftPhotoStorage');
      }
    }
    return files;
  }

  String _buildDestPath(String dirPath, String srcPath) =>
      p.join(dirPath, '$_prefixo${p.basename(srcPath)}');

  Future<void> _copiarSeNecessario(File src, String destPath) async {
    try {
      final dest = File(destPath);
      if (dest.existsSync()) {
        log('Foto já persistida: $destPath', name: 'DraftPhotoStorage');
        return;
      }
      await src.copy(destPath);
      log('Foto copiada: $destPath', name: 'DraftPhotoStorage');
    } catch (e, st) {
      log(
        'Erro ao persistir foto: $destPath',
        error: e,
        stackTrace: st,
        name: 'DraftPhotoStorage',
      );
    }
  }
}
