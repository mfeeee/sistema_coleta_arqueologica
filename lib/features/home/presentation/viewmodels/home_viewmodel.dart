import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/pino_mapa.dart';

class HomeViewModel {
  final ColetaRepository _coletaRepository;
  final BemMaterialRepository _bemMaterialRepository;

  final ValueNotifier<int> totalColetas = ValueNotifier(0);
  final ValueNotifier<int> coletasPendentes = ValueNotifier(0);
  final ValueNotifier<List<ColetaEntity>> coletasRecentes = ValueNotifier([]);
  final ValueNotifier<List<PinoMapa>> pinosNoMapa = ValueNotifier([]);
  final ValueNotifier<String> nomeUsuario;
  final ValueNotifier<String?> erroAtual = ValueNotifier(null);

  HomeViewModel({
    required ColetaRepository coletaRepository,
    required BemMaterialRepository bemMaterialRepository,
    required AuthNotifier authNotifier,
  }) : _coletaRepository = coletaRepository,
       _bemMaterialRepository = bemMaterialRepository,
       nomeUsuario = ValueNotifier(authNotifier.userName ?? '');

  Future<void> carregarDados() async {
    erroAtual.value = null;
    try {
      totalColetas.value = await _coletaRepository.contarTodas();
      coletasPendentes.value = await _coletaRepository.contarPorStatus(
        StatusColeta.pendente,
      );
      coletasRecentes.value = await _coletaRepository.getRecentes(5);

      final pinosColeta = coletasRecentes.value
          .where((c) => c.latitude != 0.0 || c.longitude != 0.0)
          .map((c) => c.paraMapa)
          .toList();

      final List<BemMaterialEntity> bens = await _bemMaterialRepository
          .getAll();
      final pinosBem = bens
          .where((b) => b.publicado)
          .map((b) => b.paraMapa)
          .whereType<PinoMapa>()
          .toList();

      pinosNoMapa.value = [...pinosColeta, ...pinosBem];
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
    pinosNoMapa.dispose();
    nomeUsuario.dispose();
    erroAtual.dispose();
  }
}
