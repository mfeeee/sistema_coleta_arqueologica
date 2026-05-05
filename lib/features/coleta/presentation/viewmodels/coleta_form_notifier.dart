import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import '../../domain/entities/coleta_entity.dart';
import 'package:uuid/uuid.dart';

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
      dadosColetados: {'foto_paths': fotoPaths},
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
