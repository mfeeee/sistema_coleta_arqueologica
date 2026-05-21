import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';

import '../../domain/entities/coleta_entity.dart';
import '../../domain/repositories/coleta_repository.dart';

class DetalhesColetaViewModel {
  DetalhesColetaViewModel({
    required ColetaRepository coletaRepository,
    required String id,
  }) : _repository = coletaRepository,
       _id = id;

  final ColetaRepository _repository;
  final String _id;

  final ValueNotifier<ColetaEntity?> coleta = ValueNotifier(null);
  final ValueNotifier<bool> carregando = ValueNotifier(false);
  final ValueNotifier<String?> erro = ValueNotifier(null);

  Future<void> carregar() async {
    carregando.value = true;
    erro.value = null;
    try {
      final resultado = await _repository.getById(_id);
      if (resultado == null) {
        erro.value = 'Coleta não encontrada.';
      } else {
        coleta.value = resultado;
      }
    } catch (e) {
      log('Erro ao carregar coleta $_id', error: e, name: 'DetalhesColeta');
      erro.value = TratadorDeErros.erroInesperado;
    } finally {
      carregando.value = false;
    }
  }

  void dispose() {
    coleta.dispose();
    carregando.dispose();
    erro.dispose();
  }
}
