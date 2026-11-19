import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
// Testes de ciclo automatizados:
// preenche → toRascunho → [banco] → restauraDeEntity
//
// Motivação: garantir end-to-end sem dependência de execução manual.

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
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

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Guarda a foto num caminho previsível (o real usa path_provider).
class _FotoStorageFake implements DraftPhotoStorage {
  @override
  Future<List<String>> persistir(List<File> files) async => [
    for (final f in files) 'persistida/${f.uri.pathSegments.last}',
  ];

  @override
  List<File> restaurar(List<String> paths) => [];
}

ColetaFormNotifier _criarNotifier({File? foto}) {
  return ColetaFormNotifier(
    mediaService: _StubMediaService(foto),
    fotoStorage: _FotoStorageFake(),
  );
}

const _artefatoCeramica = ArtefatoTipoEntity(id: '1', nome: 'Cerâmica');
const _artefatoLitico = ArtefatoTipoEntity(id: '2', nome: 'Lítico');

void _preencherFormularioCompleto(ColetaFormNotifier n) {
  n.setNome('Sítio Lapa do Sol');
  n.setNomesPopulares('Caverna do Sol, Gruta Amarela');
  n.setNatureza(NaturezaBem.bemArqueologico);
  n.setTipo(TipoBem.sitio);
  n.setLocalizacao(const LocalizacaoModel(id: 'l1', uf: 'PI'));
  n.setArtefatos([_artefatoCeramica, _artefatoLitico]);
  n.setMeiosAcesso('Estrada de terra, 5 km após o posto.');
}

// ---------------------------------------------------------------------------
// Testes de ciclo
// ---------------------------------------------------------------------------

void main() {
  group('Ciclo rascunho — dados textuais', () {
    test(
      'todos os campos sobrevivem ao ciclo cria rascunho → restaura',
      () async {
        // --- Sessão 1: usuário preenche e cria rascunho ---
        final sessao1 = _criarNotifier();
        _preencherFormularioCompleto(sessao1);
        final rascunho = await sessao1.toRascunho(usuarioId: 'u1');

        // --- Sessão 2: abre formulário com rascunho existente ---
        final sessao2 = _criarNotifier();
        sessao2.restaurarDeEntity(rascunho);

        check(sessao2.nome).equals('Sítio Lapa do Sol');
        check(sessao2.natureza).equals(NaturezaBem.bemArqueologico);
        check(sessao2.tipo).equals(TipoBem.sitio);
        check(sessao2.artefatos.map((e) => e.id)).contains('1');
        check(sessao2.artefatos.map((e) => e.id)).contains('2');
        check(
          sessao2.meiosAcesso,
        ).equals('Estrada de terra, 5 km após o posto.');
        check(
          sessao2.nomesPopulares,
        ).containsEqualInOrder(['Caverna do Sol', 'Gruta Amarela']);
        check(sessao2.temDadosRascunho).isTrue();
      },
    );

    test(
      'passoRestauracao aponta para o passo correto após restauração',
      () async {
        final sessao1 = _criarNotifier();
        _preencherFormularioCompleto(sessao1);
        final rascunho = await sessao1.toRascunho(usuarioId: 'u1');

        final sessao2 = _criarNotifier();
        sessao2.restaurarDeEntity(rascunho);

        // passo1Valido e passo2Valido → passoRestauracao == 2 (artefatos)
        check(sessao2.passoRestauracao).equals(2);
      },
    );
  });

  group('Ciclo rascunho — com foto', () {
    late Directory tempDir;
    late File fotoOrigem;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ciclo_foto_');
      fotoOrigem = File('${tempDir.path}/captura.jpg');
      await fotoOrigem.writeAsString('dados_fake_foto');
    });

    tearDown(() => tempDir.delete(recursive: true));

    test('foto persiste e é restaurada', () async {
      // --- Sessão 1: adiciona foto e gera rascunho ---
      final sessao1 = _criarNotifier(foto: fotoOrigem);
      _preencherFormularioCompleto(sessao1);
      await sessao1.adicionarFoto(ImageSource.camera);
      check(sessao1.totalMidias).equals(1);

      final rascunho = await sessao1.toRascunho(usuarioId: 'u1');

      // --- Sessão 2: restaura ---
      final sessao2 = _criarNotifier();
      sessao2.restaurarDeEntity(rascunho);

      check(sessao2.totalMidias).equals(1);
      check(sessao2.midias.first.storagePath).equals('persistida/captura.jpg');
      check(sessao2.midias.first.url).equals('');
      // A sincronização envia a foto para /v1/mobile/fotos a partir daqui.
      check(
        rascunho.dadosColetados['foto_paths'] as List,
      ).deepEquals(['persistida/captura.jpg']);
    });
  });
}
