import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/draft_photo_storage.dart';

void main() {
  late DraftPhotoStorageImpl storage;

  setUp(() {
    storage = const DraftPhotoStorageImpl();
  });

  group('DraftPhotoStorageImpl.persistir', () {
    test('lista vazia retorna lista vazia sem erro', () async {
      final result = await storage.persistir([]);

      check(result).isEmpty();
    });
  });

  group('DraftPhotoStorageImpl.restaurar', () {
    test('lista vazia retorna lista vazia', () {
      final result = storage.restaurar([]);

      check(result).isEmpty();
    });

    test('path inexistente é ignorado e retorna lista vazia sem throw', () {
      final result = storage.restaurar(['/caminho/inexistente/foto.jpg']);

      check(result).isEmpty();
    });

    test('path existente retorna File com mesmo path', () async {
      final tempDir = await Directory.systemTemp.createTemp('draft_test_');
      addTearDown(() => tempDir.delete(recursive: true));
      final arquivo = File('${tempDir.path}/foto.jpg');
      await arquivo.writeAsString('conteudo de teste');

      final result = storage.restaurar([arquivo.path]);

      check(result).length.equals(1);
      check(result.first.path).equals(arquivo.path);
    });
  });
}
