import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';

class ColetasViewModel {
  ColetasViewModel(this._repository);

  final ColetaRepository _repository;

  final ValueNotifier<List<ColetaEntity>> coletas = ValueNotifier([]);
  final ValueNotifier<bool> carregando = ValueNotifier(false);
  final ValueNotifier<String?> erro = ValueNotifier(null);

  List<ColetaEntity> get pendentes => coletas.value
      .where((c) => c.syncStatus == StatusColeta.pendente)
      .toList();

  List<ColetaEntity> get sincronizadas => coletas.value
      .where((c) => c.syncStatus == StatusColeta.sincronizado)
      .toList();

  List<ColetaEntity> get conflitos => coletas.value
      .where((c) => c.syncStatus == StatusColeta.conflito)
      .toList();

  int get totalColetas => coletas.value.length;

  int get coletasSincronizadas => sincronizadas.length;

  double get progressoSync =>
      totalColetas == 0 ? 0.0 : coletasSincronizadas / totalColetas;

  bool get todasSincronizadas =>
      totalColetas > 0 && coletasSincronizadas == totalColetas;

  Future<void> carregarColetas() async {
    carregando.value = true;
    erro.value = null;
    try {
      coletas.value = await _repository.getAll();
    } catch (e, st) {
      log(
        'Erro ao carregar coletas',
        error: e,
        stackTrace: st,
        name: 'ColetasViewModel',
      );
      erro.value = 'Não foi possível carregar as coletas.';
    } finally {
      carregando.value = false;
    }
  }

  Future<void> atualizar() => carregarColetas();

  void dispose() {
    coletas.dispose();
    carregando.dispose();
    erro.dispose();
  }
}
