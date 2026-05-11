import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import '../../../../core/utils/geolocator_helper.dart';
import '../../domain/entities/coleta_entity.dart';
import '../../domain/services/proximidade_service.dart';

export '../../../../core/utils/geolocator_helper.dart' show Coordenada;

enum ColetaStep {
  initial,
  gettingLocation,
  checkingProximity,
  proximityAlert,
  fillingForm,
  error,
  permissaoNegada,
  permissaoNegadaPermanentemente,
  gpsDesativado,
}

class ColetaViewModel {
  ColetaViewModel({
    required ProximidadeService proximidadeService,
    required GeolocatorHelper geolocatorHelper,
  }) : _proximidadeService = proximidadeService,
       _geolocatorHelper = geolocatorHelper;

  final ProximidadeService _proximidadeService;
  final GeolocatorHelper _geolocatorHelper;

  final ValueNotifier<ColetaStep> stepNotifier = ValueNotifier<ColetaStep>(
    ColetaStep.initial,
  );
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  Coordenada? coordenadaAtual;
  List<ColetaEntity> sitiosConflitantes = [];

  Future<void> iniciarMapeamento() async {
    errorMessage.value = null;
    stepNotifier.value = ColetaStep.gettingLocation;

    try {
      coordenadaAtual = await _geolocatorHelper.obterCoordenadaAtual();

      stepNotifier.value = ColetaStep.checkingProximity;

      sitiosConflitantes = await _proximidadeService.buscarBemMaterialsProximos(
        latAtual: coordenadaAtual!.latitude,
        lonAtual: coordenadaAtual!.longitude,
        raioMetros: 500.0,
      );

      stepNotifier.value = sitiosConflitantes.isNotEmpty
          ? ColetaStep.proximityAlert
          : ColetaStep.fillingForm;
    } on PermissaoNegadaException {
      errorMessage.value =
          'Permissão de localização negada. '
          'Toque em "Conceder Permissão" para solicitar novamente.';
      stepNotifier.value = ColetaStep.permissaoNegada;
    } on PermissaoNegadaPermanentementeException {
      errorMessage.value =
          'Permissão negada permanentemente. '
          'Acesse as configurações do app para habilitar a localização.';
      stepNotifier.value = ColetaStep.permissaoNegadaPermanentemente;
    } on ServicoGpsDesativadoException {
      errorMessage.value =
          'GPS desativado. '
          'Ative a localização nas configurações do dispositivo e tente novamente.';
      stepNotifier.value = ColetaStep.gpsDesativado;
    } on TimeoutException {
      errorMessage.value = TratadorDeErros.timeout;
      stepNotifier.value = ColetaStep.error;
    } catch (e) {
      errorMessage.value = TratadorDeErros.deExcecao(e);
      stepNotifier.value = ColetaStep.error;
    }
  }

  void prosseguirParaFormularioIgnorandoAlerta() {
    stepNotifier.value = ColetaStep.fillingForm;
  }

  void tentarNovamente() => iniciarMapeamento();

  void abrirConfiguracoes() => _geolocatorHelper.abrirConfiguracoes();

  void abrirConfiguracoesLocalizacao() =>
      _geolocatorHelper.abrirConfiguracoesLocalizacao();

  void dispose() {
    stepNotifier.dispose();
    errorMessage.dispose();
  }
}
