import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import "../../helpers/stub_midia_repository.dart";
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
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

ColetaFormNotifier _criarNotifier() => ColetaFormNotifier(
  uploadMidiaUseCase: StubUploadMidiaUseCase(),
  mediaService: _StubMediaService(),
);

const _artefatoCeramica = ArtefatoTipoEntity(id: '1', nome: 'Cerâmica');
const _artefatoLitico = ArtefatoTipoEntity(id: '2', nome: 'Lítico');

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
      notifier.setLocalizacao(const LocalizacaoModel(id: 'l1', uf: 'PI'));
      expect(notifier.passo1Valido, isTrue);
    });

    test('nome com somente espaços → false', () {
      final notifier = _criarNotifier();
      notifier.setNome('   ');
      notifier.setNatureza(NaturezaBem.bemArqueologico);
      notifier.setTipo(TipoBem.sitio);
      notifier.setLocalizacao(const LocalizacaoModel(id: 'l1', uf: 'PI'));
      expect(notifier.passo1Valido, isFalse);
    });
  });

  group('ColetaFormNotifier.setArtefatos', () {
    test('setArtefatos adiciona artefatos e valida passo 2', () {
      final notifier = _criarNotifier();

      notifier.setArtefatos([_artefatoCeramica]);

      expect(notifier.artefatos, contains(_artefatoCeramica));
      expect(notifier.passo2Valido, isTrue);
    });

    test('lista vazia invalida o passo 2', () {
      final notifier = _criarNotifier();
      notifier.setArtefatos([_artefatoCeramica]);
      expect(notifier.passo2Valido, isTrue);

      notifier.setArtefatos([]);

      expect(notifier.artefatos, isEmpty);
      expect(notifier.passo2Valido, isFalse);
    });

    test('isArtefatoSelecionado funciona corretamente', () {
      final notifier = _criarNotifier();

      notifier.setArtefatos([_artefatoCeramica]);

      expect(notifier.isArtefatoSelecionado(_artefatoCeramica.id), isTrue);
      expect(notifier.isArtefatoSelecionado(_artefatoLitico.id), isFalse);
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
        notifier.setLocalizacao(
          const LocalizacaoModel(
            id: 'loc-1',
            uf: 'PI',
            lat: -2.9078,
            lng: -41.7722,
          ),
        );
        notifier.setArtefatos([_artefatoCeramica, _artefatoLitico]);
        notifier.setMeiosAcesso('A pé, 30 min');
        notifier.setNomesPopulares('Pedreira, Sítio da Serra');

        final result = await notifier.toResult(usuarioId: 'usuario-42');

        expect(result.coleta.nomeBem, 'Sítio das Pedras');
        expect(result.coleta.natureza, NaturezaBem.bemArqueologico);
        expect(result.coleta.tipo, TipoBem.sitio);
        expect(
          result.coleta.artefatoTipos.map((e) => e.nome),
          containsAll(['Cerâmica', 'Lítico']),
        );
        expect(result.coleta.localizacao?.lat, closeTo(-2.9078, 0.0001));
        expect(result.coleta.localizacao?.lng, closeTo(-41.7722, 0.0001));
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
      notifier.setLocalizacao(const LocalizacaoModel(id: 'l1', uf: 'PI'));
      notifier.setArtefatos([_artefatoCeramica]);

      final result = await notifier.toResult(usuarioId: 'u1');

      expect(result.coleta.id, isNotEmpty);
      expect(result.bemMaterial.id, isNotEmpty);
      expect(result.coleta.id, isNot(equals(result.bemMaterial.id)));
      expect(result.bemMaterial.coletaId, equals(result.coleta.id));
    });
  });
}
