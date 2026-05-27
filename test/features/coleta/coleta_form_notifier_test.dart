import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coleta_form_notifier.dart';

class _StubMediaService extends MediaService {
  _StubMediaService() : super(ImagePicker());

  @override
  Future<File?> pickAndCompress(ImageSource source) async =>
      throw UnsupportedError('não deve ser chamado nos testes unitários');
}

ColetaFormNotifier _criarNotifier() =>
    ColetaFormNotifier(mediaService: _StubMediaService());

void main() {
  group('ColetaFormNotifier.passo1Valido', () {
    test('nome vazio → passo1Valido é false', () {
      final notifier = _criarNotifier();
      expect(notifier.passo1Valido, isFalse);
    });

    test('nome preenchido mas sem natureza → false', () {
      final notifier = _criarNotifier();
      notifier.setNome('Sítio A');
      expect(notifier.passo1Valido, isFalse);
    });

    test('todos os campos do passo 1 preenchidos → true', () {
      final notifier = _criarNotifier();
      notifier.setNome('Sítio A');
      notifier.setNatureza(NaturezaBem.bemArqueologico);
      notifier.setTipo(TipoBem.sitio);
      expect(notifier.passo1Valido, isTrue);
    });

    test('nome com somente espaços → false', () {
      final notifier = _criarNotifier();
      notifier.setNome('   ');
      notifier.setNatureza(NaturezaBem.bemArqueologico);
      notifier.setTipo(TipoBem.sitio);
      expect(notifier.passo1Valido, isFalse);
    });
  });

  group('ColetaFormNotifier.toggleArtefato', () {
    test('primeiro toggle adiciona artefato', () {
      final notifier = _criarNotifier();

      notifier.toggleArtefato(ArtefatoBem.ceramica);

      expect(notifier.artefatos, contains(ArtefatoBem.ceramica));
      expect(notifier.passo2Valido, isTrue);
    });

    test('segundo toggle no mesmo artefato o remove', () {
      final notifier = _criarNotifier();
      notifier.toggleArtefato(ArtefatoBem.ceramica);

      notifier.toggleArtefato(ArtefatoBem.ceramica);

      expect(notifier.artefatos, isNot(contains(ArtefatoBem.ceramica)));
      expect(notifier.passo2Valido, isFalse);
    });

    test('toggles independentes acumulam artefatos distintos', () {
      final notifier = _criarNotifier();

      notifier.toggleArtefato(ArtefatoBem.ceramica);
      notifier.toggleArtefato(ArtefatoBem.litico);

      expect(
        notifier.artefatos,
        containsAll([ArtefatoBem.ceramica, ArtefatoBem.litico]),
      );
    });

    test('remover um artefato não afeta os outros', () {
      final notifier = _criarNotifier();
      notifier.toggleArtefato(ArtefatoBem.ceramica);
      notifier.toggleArtefato(ArtefatoBem.litico);

      notifier.toggleArtefato(ArtefatoBem.ceramica);

      expect(notifier.artefatos, isNot(contains(ArtefatoBem.ceramica)));
      expect(notifier.artefatos, contains(ArtefatoBem.litico));
    });
  });

  group('ColetaFormNotifier.toResult', () {
    test(
      'retorna entity com todos os campos preenchidos corretamente',
      () async {
        final notifier = _criarNotifier();
        notifier.setNome('Sítio das Pedras');
        notifier.setNatureza(NaturezaBem.bemArqueologico);
        notifier.setTipo(TipoBem.sitio);
        notifier.toggleArtefato(ArtefatoBem.ceramica);
        notifier.toggleArtefato(ArtefatoBem.litico);
        notifier.setMeiosAcesso('A pé, 30 min');
        notifier.setNomesPopulares('Pedreira, Sítio da Serra');

        final result = await notifier.toResult(
          lat: -2.9078,
          lng: -41.7722,
          usuarioId: 'usuario-42',
        );

        expect(result.coleta.nomeBem, 'Sítio das Pedras');
        expect(result.coleta.natureza, NaturezaBem.bemArqueologico);
        expect(result.coleta.tipo, TipoBem.sitio);
        expect(
          result.coleta.artefatos,
          containsAll([ArtefatoBem.ceramica, ArtefatoBem.litico]),
        );
        expect(result.coleta.latitude, closeTo(-2.9078, 0.0001));
        expect(result.coleta.longitude, closeTo(-41.7722, 0.0001));
        expect(result.coleta.usuarioId, 'usuario-42');
        expect(result.coleta.syncStatus, StatusColeta.pendente);
        expect(result.coleta.versao, 1);
        expect(result.coleta.id, isNotEmpty);

        expect(result.bemMaterial.nomeBem, 'Sítio das Pedras');
        expect(result.bemMaterial.meiosAcesso, 'A pé, 30 min');
        expect(result.bemMaterial.nomesPopulares, contains('Pedreira'));
      },
    );

    test('id da coleta e do bemMaterial são UUIDs distintos', () async {
      final notifier = _criarNotifier();
      notifier.setNome('Sítio X');
      notifier.setNatureza(NaturezaBem.bemArqueologico);
      notifier.setTipo(TipoBem.sitio);
      notifier.toggleArtefato(ArtefatoBem.ceramica);

      final result = await notifier.toResult(
        lat: -3.0,
        lng: -42.0,
        usuarioId: 'u1',
      );

      expect(result.coleta.id, isNotEmpty);
      expect(result.bemMaterial.id, isNotEmpty);
      expect(result.coleta.id, isNot(equals(result.bemMaterial.id)));
      expect(result.bemMaterial.coletaId, equals(result.coleta.id));
    });
  });
}
