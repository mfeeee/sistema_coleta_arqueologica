// Testes de ciclo automatizados:
// preenche → salva → [logout: prefs NÃO são limpas] → login → restaura
//
// Motivação: garantir end-to-end sem dependência de execução manual.

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/draft_photo_storage.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coleta_form_notifier.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _StubMediaService extends MediaService {
  final File? _fotoRetorno;
  _StubMediaService([this._fotoRetorno]) : super(ImagePicker());

  @override
  Future<File?> pickAndCompress(ImageSource source) async => _fotoRetorno;
}

/// Simula DraftPhotoStorage real: persiste paths recebidos e restaura os que
/// existem. Não usa path_provider — opera apenas com as listas configuradas.
class _FakeDraftPhotoStorage implements DraftPhotoStorage {
  final Map<String, String> _srcParaDest;
  final List<String> _existentes;

  _FakeDraftPhotoStorage({
    Map<String, String> srcParaDest = const {},
    List<String> existentes = const [],
  }) : _srcParaDest = srcParaDest,
       _existentes = existentes;

  @override
  Future<List<String>> persistir(List<File> files) async =>
      files.map((f) => _srcParaDest[f.path] ?? f.path).toList();

  @override
  List<File> restaurar(List<String> paths) =>
      paths.where(_existentes.contains).map(File.new).toList();
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaFormNotifier _criarNotifier({File? foto, DraftPhotoStorage? storage}) {
  return ColetaFormNotifier(
    mediaService: _StubMediaService(foto),
    draftPhotoStorage: storage ?? _FakeDraftPhotoStorage(),
  );
}

void _preencherFormularioCompleto(ColetaFormNotifier n) {
  n.setNome('Sítio Lapa do Sol');
  n.setNomesPopulares('Caverna do Sol, Gruta Amarela');
  n.setNatureza(NaturezaBem.bemArqueologico);
  n.setTipo(TipoBem.sitio);
  n.toggleArtefato(ArtefatoBem.ceramica);
  n.toggleArtefato(ArtefatoBem.litico);
  n.setMeiosAcesso('Estrada de terra, 5 km após o posto.');
}

// ---------------------------------------------------------------------------
// Testes de ciclo
// ---------------------------------------------------------------------------

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('Ciclo rascunho pós-logout — dados textuais', () {
    test('todos os campos sobrevivem ao ciclo salva → restaura', () async {
      final prefs = await SharedPreferences.getInstance();

      // --- Sessão 1: usuário preenche e fecha (logout) ---
      final sessao1 = _criarNotifier();
      _preencherFormularioCompleto(sessao1);
      await sessao1.salvarRascunho(prefs);
      // Logout: SharedPreferences NÃO é limpo (comportamento intencional).

      // --- Sessão 2: usuário faz login novamente ---
      final sessao2 = _criarNotifier();
      sessao2.restaurarDePrefs(prefs);

      check(sessao2.nome).equals('Sítio Lapa do Sol');
      check(sessao2.natureza).equals(NaturezaBem.bemArqueologico);
      check(sessao2.tipo).equals(TipoBem.sitio);
      check(sessao2.artefatos).contains(ArtefatoBem.ceramica);
      check(sessao2.artefatos).contains(ArtefatoBem.litico);
      check(sessao2.meiosAcesso).equals('Estrada de terra, 5 km após o posto.');
      check(
        sessao2.nomesPopulares,
      ).containsEqualInOrder(['Caverna do Sol', 'Gruta Amarela']);
      check(sessao2.temDadosRascunho).isTrue();
    });

    test(
      'passoRestauracao aponta para o passo correto após restauração',
      () async {
        final prefs = await SharedPreferences.getInstance();

        final sessao1 = _criarNotifier();
        _preencherFormularioCompleto(sessao1);
        await sessao1.salvarRascunho(prefs);

        final sessao2 = _criarNotifier();
        sessao2.restaurarDePrefs(prefs);

        // passo1Valido e passo2Valido → passoRestauracao == 2 (artefatos)
        check(sessao2.passoRestauracao).equals(2);
      },
    );
  });

  group('Ciclo rascunho pós-logout — com foto', () {
    late Directory tempDir;
    late File fotoOrigem;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ciclo_foto_');
      fotoOrigem = File('${tempDir.path}/captura.jpg');
      await fotoOrigem.writeAsString('dados_fake_foto');
    });

    tearDown(() => tempDir.delete(recursive: true));

    test('foto persiste e é restaurada no próximo login', () async {
      final prefs = await SharedPreferences.getInstance();
      final pathPersistido = '${tempDir.path}/draft_photo_captura.jpg';

      final storageSessao1 = _FakeDraftPhotoStorage(
        srcParaDest: {fotoOrigem.path: pathPersistido},
      );
      final storageSessao2 = _FakeDraftPhotoStorage(
        existentes: [pathPersistido],
      );

      // --- Sessão 1: adiciona foto e salva ---
      final sessao1 = _criarNotifier(foto: fotoOrigem, storage: storageSessao1);
      _preencherFormularioCompleto(sessao1);
      await sessao1.adicionarFoto(ImageSource.camera);
      check(sessao1.totalFotos).equals(1);
      await sessao1.salvarRascunho(prefs);

      // --- Sessão 2: restaura ---
      final sessao2 = _criarNotifier(storage: storageSessao2);
      sessao2.restaurarDePrefs(prefs);

      check(sessao2.totalFotos).equals(1);
      check(sessao2.fotos.first.path).equals(pathPersistido);
    });

    test('foto ausente no disco é ignorada sem lançar exceção', () async {
      final prefs = await SharedPreferences.getInstance();
      const pathInexistente = '/docs/draft_photo_sumiu.jpg';

      final storageSessao1 = _FakeDraftPhotoStorage(
        srcParaDest: {fotoOrigem.path: pathInexistente},
      );
      // storageSessao2 NÃO inclui pathInexistente nos existentes
      final storageSessao2 = _FakeDraftPhotoStorage(existentes: []);

      final sessao1 = _criarNotifier(foto: fotoOrigem, storage: storageSessao1);
      _preencherFormularioCompleto(sessao1);
      await sessao1.adicionarFoto(ImageSource.camera);
      await sessao1.salvarRascunho(prefs);

      final sessao2 = _criarNotifier(storage: storageSessao2);
      check(() => sessao2.restaurarDePrefs(prefs)).returnsNormally();
      check(sessao2.totalFotos).equals(0);
    });
  });
}
