import 'package:flutter/foundation.dart';
import '../../../../core/utils/geolocator_helper.dart';
import '../../domain/entities/bem_material_cache_entity.dart';
import '../../domain/services/proximidade_service.dart';

enum ColetaStep {
  initial,
  gettingLocation,
  checkingProximity,
  proximityAlert,
  fillingForm,
  error,
}

typedef Coordenada = ({double latitude, double longitude});

class ColetaViewModel {
  final ProximidadeService _proximidadeService;
  final GeolocatorHelper _geolocatorHelper;

  ColetaViewModel({
    required ProximidadeService proximidadeService,
    required GeolocatorHelper geolocatorHelper,
  }) : _geolocatorHelper = geolocatorHelper,
       _proximidadeService = proximidadeService;

  final ValueNotifier<ColetaStep> stepNotifier = ValueNotifier<ColetaStep>(
    ColetaStep.initial,
  );
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  Coordenada? coordenadaAtual;
  List<BemMaterialCacheEntity> sitiosConflitantes = [];

  /// TODO: Implementar o fluxo de pegar GPS -> Calcular Proximidade -> Mudar Estado
  Future<void> iniciarMapeamento() async {
    try {
      errorMessage.value = null;
      stepNotifier.value = ColetaStep.gettingLocation;

      coordenadaAtual = await _geolocatorHelper.obterCoordenadaAtual();

      stepNotifier.value = ColetaStep.checkingProximity;

      sitiosConflitantes = await _proximidadeService.buscarBemMaterialsProximos(
        latAtual: coordenadaAtual!.latitude,
        lonAtual: coordenadaAtual!.longitude,
        raioMetros: 500.0,
      );

      if (sitiosConflitantes.isNotEmpty) {
        stepNotifier.value = ColetaStep.proximityAlert;
      } else {
        stepNotifier.value = ColetaStep.fillingForm;
      }
    } catch (e) {
      errorMessage.value = 'Falha ao mapear região: $e';
      stepNotifier.value = ColetaStep.error;
    }
  }

  void prosseguirParaFormularioIgnorandoAlerta() {
    stepNotifier.value = ColetaStep.fillingForm;
  }

  void tentarNovamente() {
    iniciarMapeamento();
  }

  void dispose() {
    stepNotifier.dispose();
    errorMessage.dispose();
  }
}
