import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConectividadeService {
  ConectividadeService() {
    _inicializar();
  }

  final ValueNotifier<bool> estaOnline = ValueNotifier<bool>(true);
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> _inicializar() async {
    final resultados = await Connectivity().checkConnectivity();
    estaOnline.value = _estaConectado(resultados);

    _subscription = Connectivity().onConnectivityChanged.listen((resultados) {
      estaOnline.value = _estaConectado(resultados);
      log(
        'Conectividade: ${estaOnline.value ? "online" : "offline"}',
        name: 'ConectividadeService',
      );
    });
  }

  Future<bool> verificar() async {
    final resultados = await Connectivity().checkConnectivity();
    return _estaConectado(resultados);
  }

  bool _estaConectado(List<ConnectivityResult> resultados) =>
      resultados.any((r) => r != ConnectivityResult.none);

  void dispose() {
    _subscription?.cancel();
    estaOnline.dispose();
  }
}
