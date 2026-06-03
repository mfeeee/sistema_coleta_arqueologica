import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/repositories/bem_material_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/pino_mapa.dart';

class HomeViewModel {
  final ColetaRepository _coletaRepository;
  final BemMaterialRepository _bemMaterialRepository;
  final AuthNotifier _authNotifier;
  final SecureStorageService _secureStorage;

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
    required SecureStorageService secureStorage,
  }) : _coletaRepository = coletaRepository,
       _bemMaterialRepository = bemMaterialRepository,
       _authNotifier = authNotifier,
       _secureStorage = secureStorage,
       nomeUsuario = ValueNotifier(authNotifier.userName ?? '') {
    _authNotifier.addListener(_onAuthAlterado);
  }

  void _onAuthAlterado() {
    nomeUsuario.value = _authNotifier.userName ?? '';
  }

  static bool _coordsValidas(double? lat, double? lng) =>
      lat != null &&
      lng != null &&
      lat >= -90.0 &&
      lat <= 90.0 &&
      lng >= -180.0 &&
      lng <= 180.0 &&
      !(lat == 0.0 && lng == 0.0);

  Future<void> carregarDados() async {
    erroAtual.value = null;
    try {
      final totalRemoto = await _secureStorage.getTotalColetasRemoto();
      totalColetas.value = totalRemoto ?? await _coletaRepository.contarTodas();
      coletasPendentes.value = await _coletaRepository.contarPorStatus(
        StatusColeta.pendente,
      );
      coletasRecentes.value = await _coletaRepository.getRecentes(5);
      final todasColetas = await _coletaRepository.getAll();

      final pinosColeta = todasColetas
          .where((c) => _coordsValidas(c.latitude, c.longitude))
          .map((c) => c.paraMapa)
          .whereType<PinoMapa>()
          .toList();

      final List<BemMaterialEntity> bens = await _bemMaterialRepository
          .getAll();
      final bensPublicados = bens.where((b) => b.publicado).toList();
      final pinosBem = bensPublicados
          .where((b) => _coordsValidas(b.latitude, b.longitude))
          .map((b) => b.paraMapa)
          .whereType<PinoMapa>()
          .toList();
      log(
        'bens no DB: ${bens.length} | publicados: ${bensPublicados.length} | com coords: ${pinosBem.length}',
        name: 'HomeViewModel',
      );

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
    _authNotifier.removeListener(_onAuthAlterado);
    totalColetas.dispose();
    coletasPendentes.dispose();
    coletasRecentes.dispose();
    pinosNoMapa.dispose();
    nomeUsuario.dispose();
    erroAtual.dispose();
  }
}
