import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistema_coleta_arqueologica/core/services/media_service.dart';

class ColetaFormNotifier extends ChangeNotifier {
  final MediaService _mediaService;

  ColetaFormNotifier({required MediaService mediaService})
    : _mediaService = mediaService;

  final List<File> _fotos = [];
  bool _carregandoFoto = false;

  List<File> get fotos => List.unmodifiable(_fotos);
  bool get carregandoFoto => _carregandoFoto;
  int get totalFotos => fotos.length;

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

  List<String> get fotoPaths => _fotos.map((f) => f.path).toList();

  @override
  void dispose() {
    _fotos.clear();
    super.dispose();
  }
}
