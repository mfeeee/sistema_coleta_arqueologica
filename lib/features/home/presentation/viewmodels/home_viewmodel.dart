import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';

class HomeViewModel {
  final ColetaRepository _coletaRepository;

  final ValueNotifier<int> totalColetas = ValueNotifier(0);
  final ValueNotifier<int> coletasPendentes = ValueNotifier(0);
  final ValueNotifier<List<ColetaEntity>> coletasRecentes = ValueNotifier([]);
  final ValueNotifier<String> nomeUsuario;
  final ValueNotifier<String?> erroAtual = ValueNotifier(null);

  HomeViewModel({
    required ColetaRepository coletaRepository,
    required AuthNotifier authNotifier,
  }) : _coletaRepository = coletaRepository,
       nomeUsuario = ValueNotifier(authNotifier.userName ?? '');

  Future<void> carregarDados() async {
    erroAtual.value = null;
    try {
      totalColetas.value = await _coletaRepository.contarTodas();
      coletasPendentes.value = await _coletaRepository.contarPorStatus(
        StatusColeta.pendente,
      );
      coletasRecentes.value = await _coletaRepository.getRecentes(5);
    } catch (e, st) {
      log(
        'Erro ao carregar dados da tela inicial',
        error: e,
        stackTrace: st,
        name: 'HomeViewModel',
      );
      erroAtual.value = 'Não foi possível carregar os dados.';
    }
  }

  void dispose() {
    totalColetas.dispose();
    coletasPendentes.dispose();
    coletasRecentes.dispose();
    nomeUsuario.dispose();
    erroAtual.dispose();
  }
}
