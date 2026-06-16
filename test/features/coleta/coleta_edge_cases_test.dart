import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_midia.dart';
import 'package:sistema_coleta_arqueologica/core/entities/midia_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coleta_form_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coletas_viewmodel.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import "../../helpers/stub_midia_repository.dart";

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _StubMediaService extends MediaService {
  _StubMediaService() : super(ImagePicker());
  @override
  Future<File?> pickAndCompress(ImageSource source) async => null;
}

class _StubColetaRepository implements ColetaRepository {
  final List<ColetaEntity> coletas = [];
  bool deletouChamado = false;

  @override
  Future<List<ColetaEntity>> getAll() async => coletas;
  @override
  Future<List<ColetaEntity>> getPendentes() async => [];
  @override
  Future<ColetaEntity?> getById(String uuid) async => null;
  @override
  Future<int> contarTodas() async => coletas.length;
  @override
  Future<int> contarPorStatus(StatusColeta status) async => 0;
  @override
  Future<List<ColetaEntity>> getRecentes(int limite) async => coletas;
  @override
  Future<void> salvar(ColetaEntity coleta) async {
    coletas.add(coleta);
  }

  @override
  Future<void> atualizarStatus(
    String uuid,
    dynamic status,
    int novaVersao,
  ) async {}
  @override
  Future<void> deletar(String uuid) async {
    deletouChamado = true;
    coletas.removeWhere((c) => c.id == uuid);
  }
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('Coleta Edge Cases — Form Notifier', () {
    test('Abrir sem rascunho (estado inicial)', () {
      final notifier = ColetaFormNotifier(
        uploadMidiaUseCase: StubUploadMidiaUseCase(),
        mediaService: _StubMediaService(),
      );

      check(notifier.nome).isEmpty();
      check(notifier.natureza).isNull();
      check(notifier.tipo).isNull();
      check(notifier.localizacao).isNull();
      check(notifier.artefatos).isEmpty();
      check(notifier.temDadosRascunho).isFalse();
      check(notifier.modificado).isFalse();
    });

    test('Restauração de rascunho parcial (apenas nome)', () {
      final entity = ColetaEntity(
        id: 'c2',
        nomeBem: 'Rascunho Parcial',
        dataColeta: DateTime.now(),
        updatedAt: DateTime.now(),
        versao: 1,
        usuarioId: 'u1',
        artefatoTipos: [],
        syncStatus: StatusColeta.rascunho,
        dadosColetados: {},
      );

      final notifier = ColetaFormNotifier(
        uploadMidiaUseCase: StubUploadMidiaUseCase(),
        mediaService: _StubMediaService(),
      );

      notifier.restaurarDeEntity(entity);

      check(notifier.nome).equals('Rascunho Parcial');
      check(notifier.natureza).isNull();
      check(notifier.localizacao).isNull();
      check(notifier.temDadosRascunho).isTrue();
    });

    test('Editar rascunho com fotos já vinculadas', () async {
      final entity = ColetaEntity(
        id: 'c3',
        nomeBem: 'Com Foto',
        dataColeta: DateTime.now(),
        updatedAt: DateTime.now(),
        versao: 1,
        usuarioId: 'u1',
        artefatoTipos: [],
        syncStatus: StatusColeta.rascunho,
        dadosColetados: {},
        midias: [
          const MidiaEntity(
            id: 'm1',
            mediableType: 'coleta',
            mediableId: 'c3',
            storagePath: 'foto1.jpg',
            mimeType: 'image/jpeg',
            tipo: TipoMidia.imagem,
            url: 'http://...',
          ),
        ],
      );

      final notifier = ColetaFormNotifier(
        uploadMidiaUseCase: StubUploadMidiaUseCase(),
        mediaService: _StubMediaService(),
      );

      notifier.restaurarDeEntity(entity);

      check(notifier.totalMidias).equals(1);
      check(notifier.midias.first.storagePath).equals('foto1.jpg');
    });

    test('Finalizar offline (toResult gera entidade local)', () async {
      final notifier = ColetaFormNotifier(
        uploadMidiaUseCase: StubUploadMidiaUseCase(),
        mediaService: _StubMediaService(),
      );

      notifier.setNome('Teste Offline');
      notifier.setNatureza(NaturezaBem.bemArqueologico);
      notifier.setTipo(TipoBem.sitio);
      notifier.setLocalizacao(const LocalizacaoModel(id: 'l1', uf: 'PI'));
      notifier.setArtefatos([
        const ArtefatoTipoEntity(id: 'a1', nome: 'Artefato'),
      ]);

      final result = await notifier.toResult(usuarioId: 'u1');

      check(result.coleta.nomeBem).equals('Teste Offline');
      check(result.coleta.syncStatus).equals(StatusColeta.pendente);
    });

    test('Modificado flag funciona corretamente', () {
      final notifier = ColetaFormNotifier(
        uploadMidiaUseCase: StubUploadMidiaUseCase(),
        mediaService: _StubMediaService(),
      );

      check(notifier.modificado).isFalse();

      notifier.setNome('Novo Nome');
      check(notifier.modificado).isTrue();

      notifier.resetModificado();
      check(notifier.modificado).isFalse();

      notifier.setNatureza(NaturezaBem.bemPaleontologico);
      check(notifier.modificado).isTrue();
    });
  });

  group('Coleta Edge Cases — View Model', () {
    test(
      'Exclusão de rascunho remove do repositório e atualiza lista',
      () async {
        final repo = _StubColetaRepository();
        final vm = ColetasViewModel(repo);

        final rascunho = ColetaEntity(
          id: 'r1',
          nomeBem: 'Rascunho a Deletar',
          dataColeta: DateTime.now(),
          updatedAt: DateTime.now(),
          versao: 1,
          usuarioId: 'u1',
          artefatoTipos: [],
          syncStatus: StatusColeta.rascunho,
          dadosColetados: {},
        );

        await repo.salvar(rascunho);
        await vm.carregarColetas();
        check(vm.rascunhos).length.equals(1);

        await vm.deletarColeta('r1');

        check(repo.deletouChamado).isTrue();
        check(vm.rascunhos).isEmpty();
      },
    );
  });
}
