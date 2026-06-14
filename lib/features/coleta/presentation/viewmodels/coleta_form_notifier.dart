import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/core/models/midia_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import 'package:sistema_coleta_arqueologica/core/models/artefato_tipo_model.dart';
import 'package:sistema_coleta_arqueologica/features/media/domain/usecases/upload_midia_usecase.dart';
import '../../domain/entities/coleta_entity.dart';
import '../../domain/usecases/criar_coleta_use_case.dart';

const _kChaveRascunho = 'rascunho_coleta';

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

  List<MidiaModel> get midias => List.unmodifiable(_midias);
  bool get carregandoMidia => _carregandoMidia;
  int get totalMidias => _midias.length;

  // Mutacoes passo 1
  void setNome(String value) {
    nome = value;
    notifyListeners();
  }

  void setNomesPopulares(String raw) {
    nomesPopulares = raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    notifyListeners();
  }

  void setNatureza(NaturezaBem? value) {
    natureza = value;
    notifyListeners();
  }

  void setTipo(TipoBem? value) {
    tipo = value;
    notifyListeners();
  }

  void setLocalizacao(LocalizacaoModel? value) {
    localizacao = value;
    notifyListeners();
  }

  // Mutacoes passo 2
  void setArtefatos(List<ArtefatoTipoEntity> values) {
    _artefatos.clear();
    _artefatos.addAll(values);
    notifyListeners();
  }

  bool isArtefatoSelecionado(String typeId) =>
      _artefatos.any((e) => e.id == typeId);

  // Mutacoes passo 3
  void setMeiosAcesso(String? value) {
    meiosAcesso = value;
    notifyListeners();
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
    notifyListeners();
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

  // Rascunho
  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'nomes_populares': nomesPopulares,
    'natureza': natureza?.name,
    'tipo': tipo?.name,
    'localizacao': localizacao?.toJson(),
    'artefatos': _artefatos
        .map(
          (a) => ArtefatoTipoModel(
            id: a.id,
            nome: a.nome,
            descricaoNova: a.descricaoNova,
            novoTipo: a.novoTipo,
          ).toJson(),
        )
        .toList(),
    'meios_acesso': meiosAcesso,
    'midias': _midias.map((m) => m.toJson()).toList(),
  };

  void _restaurarDeMap(Map<String, dynamic> map) {
    nome = map['nome'] as String? ?? '';
    nomesPopulares = (map['nomes_populares'] as List?)?.cast<String>() ?? [];

    final naturezaStr = map['natureza'] as String?;
    if (naturezaStr != null) {
      try {
        natureza = NaturezaBem.fromString(naturezaStr);
      } catch (_) {
        natureza = null;
      }
    }

    final tipoStr = map['tipo'] as String?;
    if (tipoStr != null) {
      try {
        tipo = TipoBem.fromString(tipoStr);
      } catch (_) {
        tipo = null;
      }
    }

    if (map['localizacao'] != null) {
      localizacao = LocalizacaoModel.fromJson(
        map['localizacao'] as Map<String, dynamic>,
      );
    }

    _artefatos.clear();
    final artefatosJson = (map['artefatos'] as List?) ?? [];
    for (final a in artefatosJson) {
      _artefatos.add(ArtefatoTipoModel.fromJson(a as Map<String, dynamic>));
    }

    meiosAcesso = map['meios_acesso'] as String?;

    _midias.clear();
    final midiasJson = (map['midias'] as List?) ?? [];
    for (final m in midiasJson) {
      _midias.add(MidiaModel.fromJson(m as Map<String, dynamic>));
    }
  }

  void restaurarDePrefs(SharedPreferences prefs) {
    final json = prefs.getString(_kChaveRascunho);
    if (json == null) return;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      _restaurarDeMap(map);
      notifyListeners();
      log('Rascunho restaurado', name: 'ColetaFormNotifier');
    } catch (e, st) {
      log(
        'Erro ao restaurar rascunho',
        error: e,
        stackTrace: st,
        name: 'ColetaFormNotifier',
      );
    }
  }

  Future<void> salvarRascunho(SharedPreferences prefs) async {
    if (!temDadosRascunho) return;
    try {
      final map = toMap();
      await prefs.setString(_kChaveRascunho, jsonEncode(map));
      log(
        'Rascunho salvo (${_midias.length} mídias)',
        name: 'ColetaFormNotifier',
      );
    } catch (e, st) {
      log(
        'Erro ao salvar rascunho',
        error: e,
        stackTrace: st,
        name: 'ColetaFormNotifier',
      );
    }
  }

  Future<void> descartarRascunho(SharedPreferences prefs) async {
    await prefs.remove(_kChaveRascunho);
    log('Rascunho descartado', name: 'ColetaFormNotifier');
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
