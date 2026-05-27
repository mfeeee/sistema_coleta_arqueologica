import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/draft_photo_storage.dart';

// ---------------------------------------------------------------------------
// Fake path_provider
// ---------------------------------------------------------------------------

class _FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final Directory dir;
  _FakePathProviderPlatform(this.dir);

  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Future<File> _criarArquivoTemp(Directory dir, String nome) async {
  final file = File('${dir.path}/$nome');
  await file.writeAsString('conteudo de teste');
  return file;
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  late Directory tempDir;
  late Directory docsDir;
  late DraftPhotoStorageImpl storage;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('src_');
    docsDir = await Directory.systemTemp.createTemp('docs_');
    PathProviderPlatform.instance = _FakePathProviderPlatform(docsDir);
    storage = const DraftPhotoStorageImpl();
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
    await docsDir.delete(recursive: true);
  });

  group('DraftPhotoStorage.persistir', () {
    test('lista vazia retorna lista vazia sem erros', () async {
      final paths = await storage.persistir([]);

      check(paths).isEmpty();
    });

    test('copia arquivo existente e retorna path em docsDir', () async {
      final src = await _criarArquivoTemp(tempDir, 'foto.jpg');

      final paths = await storage.persistir([src]);

      check(paths).length.equals(1);
      check(paths.first).contains(docsDir.path);
      check(File(paths.first).existsSync()).isTrue();
    });

    test('é idempotente — segunda chamada não duplica arquivo', () async {
      final src = await _criarArquivoTemp(tempDir, 'foto2.jpg');

      final paths1 = await storage.persistir([src]);
      final paths2 = await storage.persistir([src]);

      check(paths1).deepEquals(paths2);
      final arquivos = docsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('draft_photo_'))
          .toList();
      check(arquivos).length.equals(1);
    });
  });

  group('DraftPhotoStorage.restaurar', () {
    test('path válido retorna File correspondente', () async {
      final src = await _criarArquivoTemp(tempDir, 'foto3.jpg');

      final files = storage.restaurar([src.path]);

      check(files).length.equals(1);
      check(files.first.path).equals(src.path);
    });

    test('path inexistente é ignorado e retorna lista vazia', () {
      final files = storage.restaurar(['/caminho/que/nao/existe.jpg']);

      check(files).isEmpty();
    });

    test(
      'mistura de paths válidos e inválidos retorna apenas os válidos',
      () async {
        final src = await _criarArquivoTemp(tempDir, 'foto4.jpg');

        final files = storage.restaurar([src.path, '/nao/existe.jpg']);

        check(files).length.equals(1);
        check(files.first.path).equals(src.path);
      },
    );
  });
}
