import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/core/models/midia_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import 'package:sistema_coleta_arqueologica/features/media/domain/usecases/upload_midia_usecase.dart';
import '../../domain/entities/coleta_entity.dart';
import '../../domain/usecases/criar_coleta_use_case.dart';

class ColetaFormNotifier extends ChangeNotifier {
  final String id;
  final MediaService _mediaService;
  final UploadMidiaUseCase _uploadMidiaUseCase;
  final CriarColetaUseCase _criarColetaUseCase;

  ColetaFormNotifier({
    String? id,
    required MediaService mediaService,
    required UploadMidiaUseCase uploadMidiaUseCase,
    CriarColetaUseCase criarColetaUseCase = const CriarColetaUseCase(),
  }) : id = id ?? const Uuid().v4(),
       _mediaService = mediaService,
       _uploadMidiaUseCase = uploadMidiaUseCase,
       _criarColetaUseCase = criarColetaUseCase;

  // Passo 1
  String nome = '';
  List<String> nomesPopulares = [];
  NaturezaBem? natureza;
  TipoBem? tipo;
  LocalizacaoModel? localizacao;

  // Passo 2
  final List<ArtefatoTipoEntity> _artefatos = [];
  List<ArtefatoTipoEntity> get artefatos => List.unmodifiable(_artefatos);

  // Passo 3
  String? meiosAcesso;
  bool transcrevendo = false;

  final List<MidiaModel> _midias = [];
  bool _carregandoMidia = false;

  bool _modificado = false;
  bool get modificado => _modificado;

  List<MidiaModel> get midias => List.unmodifiable(_midias);
  bool get carregandoMidia => _carregandoMidia;
  int get totalMidias => _midias.length;

  void _marcarModificado() {
    _modificado = true;
    notifyListeners();
  }

  // Mutacoes passo 1
  void setNome(String value) {
    if (nome == value) return;
    nome = value;
    _marcarModificado();
  }

  void setNomesPopulares(String raw) {
    final novosNomes = raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (listEquals(nomesPopulares, novosNomes)) return;
    nomesPopulares = novosNomes;
    _marcarModificado();
  }

  void setNatureza(NaturezaBem? value) {
    if (natureza == value) return;
    natureza = value;
    _marcarModificado();
  }

  void setTipo(TipoBem? value) {
    if (tipo == value) return;
    tipo = value;
    _marcarModificado();
  }

  void setLocalizacao(LocalizacaoModel? value) {
    if (localizacao == value) return;
    localizacao = value;
    _marcarModificado();
  }

  // Mutacoes passo 2
  void setArtefatos(List<ArtefatoTipoEntity> values) {
    _artefatos.clear();
    _artefatos.addAll(values);
    _marcarModificado();
  }

  bool isArtefatoSelecionado(String typeId) =>
      _artefatos.any((e) => e.id == typeId);

  // Mutacoes passo 3
  void setMeiosAcesso(String? value) {
    if (meiosAcesso == value) return;
    meiosAcesso = value;
    _marcarModificado();
  }

  Future<void> adicionarFoto(ImageSource source) async {
    if (_carregandoMidia) return;

    _carregandoMidia = true;
    notifyListeners();

    try {
      final file = await _mediaService.pickAndCompress(source);
      if (file != null) {
        final midia = await _uploadMidiaUseCase(
          file: file,
          mediableType: 'coleta',
          mediableId: id,
          tipo: 'foto',
        );
        _midias.add(midia);
        _marcarModificado();
      }
    } catch (e) {
      log('Erro ao adicionar foto', error: e, name: 'ColetaFormNotifier');
    } finally {
      _carregandoMidia = false;
      notifyListeners();
    }
  }

  void removerMidia(int index) {
    if (index < 0 || index >= _midias.length) return;
    _midias.removeAt(index);
    _marcarModificado();
  }

  // Validação
  bool get passo1Valido =>
      nome.trim().isNotEmpty &&
      natureza != null &&
      tipo != null &&
      localizacao?.uf != null &&
      localizacao!.uf!.isNotEmpty;

  bool get passo2Valido => _artefatos.isNotEmpty;

  bool get temDadosRascunho =>
      nome.isNotEmpty ||
      natureza != null ||
      _artefatos.isNotEmpty ||
      _midias.isNotEmpty ||
      localizacao != null;

  int get passoRestauracao {
    if (passo1Valido && passo2Valido) return 2;
    if (passo1Valido) return 1;
    return 0;
  }

  void restaurarDeEntity(ColetaEntity entity) {
    nome = entity.nomeBem;
    natureza = entity.natureza;
    tipo = entity.tipo;

    if (entity.localizacao != null) {
      localizacao = LocalizacaoModel(
        id: entity.localizacao!.id,
        lat: entity.localizacao!.lat,
        lng: entity.localizacao!.lng,
        uf: entity.localizacao!.uf,
        municipio: entity.localizacao!.municipio,
        cep: entity.localizacao!.cep,
        logradouro: entity.localizacao!.logradouro,
      );
    }

    _artefatos.clear();
    _artefatos.addAll(entity.artefatoTipos);

    nomesPopulares =
        (entity.dadosColetados['nomes_populares'] as List?)?.cast<String>() ??
        [];
    meiosAcesso = entity.dadosColetados['meios_acesso'] as String?;

    _midias.clear();
    for (final m in entity.midias) {
      _midias.add(
        MidiaModel(
          id: m.id,
          mediableType: m.mediableType,
          mediableId: m.mediableId,
          storagePath: m.storagePath,
          mimeType: m.mimeType,
          tipo: m.tipo,
          url: m.url,
          descricao: m.descricao,
        ),
      );
    }

    _modificado = false;
    notifyListeners();
    log(
      'Estado restaurado de ColetaEntity (${entity.id})',
      name: 'ColetaFormNotifier',
    );
  }

  void resetModificado() {
    _modificado = false;
    notifyListeners();
  }

  Future<ColetaEntity> toRascunho({required String usuarioId}) async {
    return _criarColetaUseCase.criarRascunho(
      CriarColetaInput(
        id: id,
        nome: nome,
        nomesPopulares: nomesPopulares,
        natureza: natureza,
        tipo: tipo,
        localizacao: localizacao,
        artefatoTipos: _artefatos,
        meiosAcesso: meiosAcesso,
        midias: _midias,
        usuarioId: usuarioId,
      ),
    );
  }

  Future<ColetaFormResult> toResult({required String usuarioId}) async {
    assert(passo1Valido, 'toResult() chamado com Passo 1 inválido');
    assert(passo2Valido, 'toResult() chamado com nenhum artefato selecionado');

    return _criarColetaUseCase.call(
      CriarColetaInput(
        id: id,
        nome: nome,
        nomesPopulares: nomesPopulares,
        natureza: natureza,
        tipo: tipo,
        localizacao: localizacao,
        artefatoTipos: _artefatos,
        meiosAcesso: meiosAcesso,
        midias: _midias,
        usuarioId: usuarioId,
      ),
    );
  }

  @override
  void dispose() {
    _midias.clear();
    super.dispose();
  }
}
