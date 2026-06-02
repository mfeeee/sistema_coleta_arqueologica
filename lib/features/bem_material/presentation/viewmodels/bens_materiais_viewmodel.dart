import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';

class BensMateriaisViewModel {
  BensMateriaisViewModel(this._repository);

  final BemMaterialRepository _repository;

  final ValueNotifier<List<BemMaterialEntity>> bens = ValueNotifier([]);
  final ValueNotifier<bool> carregando = ValueNotifier(false);
  final ValueNotifier<String?> erro = ValueNotifier(null);

  Future<void> carregar(String coletaId) async {
    carregando.value = true;
    erro.value = null;
    try {
      bens.value = await _repository.getByColetaId(coletaId);
    } catch (e, st) {
      log(
        'Erro ao carregar bens materiais',
        error: e,
        stackTrace: st,
        name: 'BensMateriaisViewModel',
      );
      erro.value = 'Não foi possível carregar os bens materiais.';
    } finally {
      carregando.value = false;
    }
  }

  void dispose() {
    bens.dispose();
    carregando.dispose();
    erro.dispose();
  }
}
