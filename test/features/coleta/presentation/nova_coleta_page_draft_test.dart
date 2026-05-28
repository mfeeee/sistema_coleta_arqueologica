import 'dart:convert';
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

class FakeDraftPhotoStorage implements DraftPhotoStorage {
  @override
  Future<List<String>> persistir(List<File> files) async => [];

  @override
  List<File> restaurar(List<String> paths) => [];
}

class _StubMediaService extends MediaService {
  _StubMediaService() : super(ImagePicker());

  @override
  Future<File?> pickAndCompress(ImageSource source) async =>
      throw UnsupportedError('não deve ser chamado nos testes unitários');
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaFormNotifier _criarNotifier() => ColetaFormNotifier(
  mediaService: _StubMediaService(),
  draftPhotoStorage: FakeDraftPhotoStorage(),
);

void _preencherPasso1(ColetaFormNotifier notifier) {
  notifier.setNome('Sítio Aratu');
  notifier.setNatureza(NaturezaBem.bemArqueologico);
  notifier.setTipo(TipoBem.sitio);
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'sem rascunho: formulário abre em branco e passoRestauracao é 0',
    () async {
      final prefs = await SharedPreferences.getInstance();
      final notifier = _criarNotifier();

      notifier.restaurarDePrefs(prefs);

      check(notifier.nome).equals('');
      check(notifier.natureza).isNull();
      check(notifier.tipo).isNull();
      check(notifier.artefatos).isEmpty();
      check(notifier.passoRestauracao).equals(0);
    },
  );

  test(
    'rascunho com passo 1 válido: passoRestauracao é 1 e campos preenchidos',
    () async {
      final prefs = await SharedPreferences.getInstance();
      final notifierA = _criarNotifier();
      _preencherPasso1(notifierA);
      await notifierA.salvarRascunho(prefs);

      final notifierB = _criarNotifier();
      notifierB.restaurarDePrefs(prefs);

      check(notifierB.nome).equals('Sítio Aratu');
      check(notifierB.natureza).equals(NaturezaBem.bemArqueologico);
      check(notifierB.tipo).equals(TipoBem.sitio);
      check(notifierB.passoRestauracao).equals(1);
    },
  );

  test('rascunho com passo 1 e 2 válidos: passoRestauracao é 2', () async {
    final prefs = await SharedPreferences.getInstance();
    final notifierA = _criarNotifier();
    _preencherPasso1(notifierA);
    notifierA.toggleArtefato(ArtefatoBem.ceramica);
    await notifierA.salvarRascunho(prefs);

    final notifierB = _criarNotifier();
    notifierB.restaurarDePrefs(prefs);

    check(notifierB.artefatos).contains(ArtefatoBem.ceramica);
    check(notifierB.passoRestauracao).equals(2);
  });

  test(
    'foto_paths com arquivo inexistente é ignorado e fotos fica vazio',
    () async {
      SharedPreferences.setMockInitialValues({
        'rascunho_coleta': jsonEncode({
          'nome': 'Sítio',
          'nomes_populares': <String>[],
          'natureza': null,
          'tipo': null,
          'artefatos': <String>[],
          'meios_acesso': null,
          'foto_paths': ['/caminho/inexistente/foto.jpg'],
        }),
      });
      final prefs = await SharedPreferences.getInstance();
      final notifier = _criarNotifier();

      notifier.restaurarDePrefs(prefs);

      check(notifier.fotos).isEmpty();
    },
  );

  test('descartarRascunho remove a chave rascunho_coleta do prefs', () async {
    final prefs = await SharedPreferences.getInstance();
    final notifier = _criarNotifier();
    _preencherPasso1(notifier);
    await notifier.salvarRascunho(prefs);
    check(prefs.containsKey('rascunho_coleta')).isTrue();

    await notifier.descartarRascunho(prefs);

    check(prefs.containsKey('rascunho_coleta')).isFalse();
  });
}
