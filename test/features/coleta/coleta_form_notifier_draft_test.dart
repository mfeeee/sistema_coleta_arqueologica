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
// Fakes manuais
// ---------------------------------------------------------------------------

class _StubMediaService extends MediaService {
  _StubMediaService() : super(ImagePicker());

  @override
  Future<File?> pickAndCompress(ImageSource source) async =>
      throw UnsupportedError('não deve ser chamado nos testes unitários');
}

class _SpyDraftPhotoStorage implements DraftPhotoStorage {
  final List<List<File>> chamadasPersistir = [];
  final List<List<String>> chamadasRestaurar = [];

  List<String> retornoPersistir = [];
  List<File> retornoRestaurar = [];

  @override
  Future<List<String>> persistir(List<File> files) async {
    chamadasPersistir.add(List.of(files));
    return retornoPersistir;
  }

  @override
  List<File> restaurar(List<String> paths) {
    chamadasRestaurar.add(List.of(paths));
    return retornoRestaurar;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaFormNotifier _criarNotifier(_SpyDraftPhotoStorage spy) =>
    ColetaFormNotifier(
      mediaService: _StubMediaService(),
      draftPhotoStorage: spy,
    );

void _preencherPasso1(ColetaFormNotifier n) {
  n.setNome('Sítio Teste');
  n.setNatureza(NaturezaBem.bemArqueologico);
  n.setTipo(TipoBem.sitio);
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ColetaFormNotifier.salvarRascunho', () {
    test('chama persistir quando temDadosRascunho', () async {
      final spy = _SpyDraftPhotoStorage();
      final notifier = _criarNotifier(spy);
      _preencherPasso1(notifier);
      final prefs = await SharedPreferences.getInstance();

      await notifier.salvarRascunho(prefs);

      check(spy.chamadasPersistir).length.equals(1);
    });

    test('não chama persistir quando formulário vazio', () async {
      final spy = _SpyDraftPhotoStorage();
      final notifier = _criarNotifier(spy);
      final prefs = await SharedPreferences.getInstance();

      await notifier.salvarRascunho(prefs);

      check(spy.chamadasPersistir).isEmpty();
    });

    test('salva paths retornados por persistir no SharedPreferences', () async {
      final spy = _SpyDraftPhotoStorage();
      spy.retornoPersistir = ['/docs/draft_photo_a.jpg'];
      final notifier = _criarNotifier(spy);
      _preencherPasso1(notifier);
      final prefs = await SharedPreferences.getInstance();

      await notifier.salvarRascunho(prefs);

      final json = prefs.getString('rascunho_coleta');
      check(json).isNotNull();
      check(json!).contains('draft_photo_a.jpg');
    });
  });

  group('ColetaFormNotifier.restaurarDePrefs', () {
    test('restaura nome, natureza e artefatos corretamente', () async {
      final spy = _SpyDraftPhotoStorage();
      final notifierA = _criarNotifier(spy);
      _preencherPasso1(notifierA);
      notifierA.toggleArtefato(ArtefatoBem.ceramica);
      final prefs = await SharedPreferences.getInstance();
      await notifierA.salvarRascunho(prefs);

      final notifierB = _criarNotifier(_SpyDraftPhotoStorage());
      notifierB.restaurarDePrefs(prefs);

      check(notifierB.nome).equals('Sítio Teste');
      check(notifierB.natureza).equals(NaturezaBem.bemArqueologico);
      check(notifierB.artefatos).contains(ArtefatoBem.ceramica);
    });

    test('chama restaurar com os paths do JSON', () async {
      final spyA = _SpyDraftPhotoStorage();
      spyA.retornoPersistir = ['/docs/draft_photo_x.jpg'];
      final notifierA = _criarNotifier(spyA);
      _preencherPasso1(notifierA);
      final prefs = await SharedPreferences.getInstance();
      await notifierA.salvarRascunho(prefs);

      final spyB = _SpyDraftPhotoStorage();
      final notifierB = _criarNotifier(spyB);
      notifierB.restaurarDePrefs(prefs);

      check(spyB.chamadasRestaurar).length.equals(1);
      check(spyB.chamadasRestaurar.first).contains('/docs/draft_photo_x.jpg');
    });

    test('com JSON corrompido não lança exceção', () async {
      SharedPreferences.setMockInitialValues({
        'rascunho_coleta': '{json_invalido:::',
      });
      final spy = _SpyDraftPhotoStorage();
      final notifier = _criarNotifier(spy);
      final prefs = await SharedPreferences.getInstance();

      check(() => notifier.restaurarDePrefs(prefs)).returnsNormally();
    });
  });
}
