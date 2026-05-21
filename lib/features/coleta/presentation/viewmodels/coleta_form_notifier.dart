import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import '../../domain/entities/coleta_entity.dart';
import 'package:uuid/uuid.dart';

const _kChaveRascunho = 'rascunho_coleta';

class ColetaFormResult {
  final ColetaEntity coleta;
  final BemMaterialEntity bemMaterial;
  const ColetaFormResult({required this.coleta, required this.bemMaterial});
}

class ColetaFormNotifier extends ChangeNotifier {
  final MediaService _mediaService;

  ColetaFormNotifier({required MediaService mediaService})
    : _mediaService = mediaService;

  // Passo 1
  String nome = '';
  List<String> nomesPopulares = [];
  NaturezaBem? natureza;
  TipoBem? tipo;

  // Passo 2
  final Set<ArtefatoBem> _artefatos = {};
  Set<ArtefatoBem> get artefatos => Set.unmodifiable(_artefatos);

  // Passo 3
  String? meiosAcesso;
  bool transcrevendo = false;

  final List<File> _fotos = [];
  bool _carregandoFoto = false;

  List<File> get fotos => List.unmodifiable(_fotos);
  bool get carregandoFoto => _carregandoFoto;
  int get totalFotos => fotos.length;
  List<String> get fotoPaths => _fotos.map((f) => f.path).toList();

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

  // Mutacoes passo 2
  void toggleArtefato(ArtefatoBem artefato) {
    if (_artefatos.contains(artefato)) {
      _artefatos.remove(artefato);
    } else {
      _artefatos.add(artefato);
    }
    notifyListeners();
  }

  bool isArtefatoSelecionado(ArtefatoBem artefato) =>
      _artefatos.contains(artefato);

  // Mutacoes passo 3

  void setMeiosAcesso(String? value) {
    meiosAcesso = value;
    notifyListeners();
  }

  Future<void> adicionarFoto(ImageSource source) async {
    if (_carregandoFoto) return;

    _carregandoFoto = true;
    notifyListeners();

    try {
      final file = await _mediaService.pickAndCompress(source);
      if (file != null) {
        _fotos.add(file);
      }
    } catch (e) {
      log('Erro ao adicionar foto', error: e, name: 'ColetaFormNotifier');
    } finally {
      _carregandoFoto = false;
      notifyListeners();
    }
  }

  void removerFoto(int index) {
    if (index < 0 || index >= _fotos.length) return;
    _fotos.removeAt(index);
    notifyListeners();
  }

  // Validação
  bool get passo1Valido =>
      nome.trim().isNotEmpty && natureza != null && tipo != null;

  bool get passo2Valido => _artefatos.isNotEmpty;

  bool get temDadosRascunho =>
      nome.isNotEmpty || natureza != null || _artefatos.isNotEmpty;

  int get passoRestauracao {
    if (passo1Valido && passo2Valido) return 2;
    if (passo1Valido) return 1;
    return 0;
  }

  // Rascunho
  Map<String, dynamic> toMap() => {
    'nome': nome,
    'nomes_populares': nomesPopulares,
    'natureza': natureza?.name,
    'tipo': tipo?.name,
    'artefatos': _artefatos.map((a) => a.name).toList(),
    'meios_acesso': meiosAcesso,
    'foto_paths': fotoPaths,
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

    _artefatos.clear();
    for (final a in (map['artefatos'] as List?)?.cast<String>() ?? []) {
      final artefato = ArtefatoBem.tryFromString(a);
      if (artefato != null) _artefatos.add(artefato);
    }

    meiosAcesso = map['meios_acesso'] as String?;
    // foto_paths: file paths são mantidos na serialização, mas File objects
    // não são restaurados para evitar acesso a arquivos possivelmente ausentes.
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
      await prefs.setString(_kChaveRascunho, jsonEncode(toMap()));
      log('Rascunho salvo', name: 'ColetaFormNotifier');
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

  ColetaEntity toRascunho({
    required double lat,
    required double lng,
    required String usuarioId,
  }) {
    final agora = DateTime.now();
    return ColetaEntity(
      id: const Uuid().v4(),
      usuarioId: usuarioId,
      dataColeta: agora,
      syncStatus: StatusColeta.rascunho,
      nomeBem: nome.trim().isEmpty ? 'Rascunho' : nome.trim(),
      natureza: natureza,
      tipo: tipo,
      artefatos: _artefatos.toList(),
      latitude: lat,
      longitude: lng,
      versao: 1,
      updatedAt: agora,
      dadosColetados: {
        'nomes_populares': nomesPopulares,
        'meios_acesso': meiosAcesso,
        'foto_paths': fotoPaths,
      },
    );
  }

  ColetaFormResult toResult({
    required double lat,
    required double lng,
    required String usuarioId,
  }) {
    assert(passo1Valido, 'toResult() chamado com Passo 1 inválido');
    assert(passo2Valido, 'toResult() chamado com nenhum artefato selecionado');

    final coletaId = const Uuid().v4();
    final agora = DateTime.now();

    final coleta = ColetaEntity(
      id: coletaId,
      usuarioId: usuarioId,
      dataColeta: agora,
      syncStatus: StatusColeta.pendente,
      nomeBem: nome.trim(),
      natureza: natureza,
      tipo: tipo,
      artefatos: _artefatos.toList(),
      latitude: lat,
      longitude: lng,
      versao: 1,
      updatedAt: agora,
      dadosColetados: {
        'nomes_populares': nomesPopulares,
        'meios_acesso': meiosAcesso,
        'foto_paths': fotoPaths,
      },
    );

    final bemMaterial = BemMaterialEntity(
      id: const Uuid().v4(),
      coletaId: coletaId,
      nomeBem: nome.trim(),
      nomesPopulares: nomesPopulares,
      natureza: natureza!.name,
      tipo: tipo!.name,
      meiosAcesso: meiosAcesso?.trim(),
      artefatos: _artefatos.toList(),
      publicado: false,
      criadoEm: agora,
      atualizadoEm: agora,
    );

    return ColetaFormResult(coleta: coleta, bemMaterial: bemMaterial);
  }

  @override
  void dispose() {
    _fotos.clear();
    super.dispose();
  }
}
