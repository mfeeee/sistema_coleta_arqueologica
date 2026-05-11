import 'package:geolocator/geolocator.dart';

typedef Coordenada = ({double latitude, double longitude});

sealed class GpsException implements Exception {
  const GpsException();
}

final class ServicoGpsDesativadoException extends GpsException {
  const ServicoGpsDesativadoException();
}

final class PermissaoNegadaException extends GpsException {
  const PermissaoNegadaException();
}

final class PermissaoNegadaPermanentementeException extends GpsException {
  const PermissaoNegadaPermanentementeException();
}

class GeolocatorHelper {
  static const _configuracoes = LocationSettings(
    accuracy: LocationAccuracy.high,
    timeLimit: Duration(seconds: 15),
  );

  Future<Coordenada> obterCoordenadaAtual() async {
    final servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) throw const ServicoGpsDesativadoException();

    var permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.deniedForever) {
      throw const PermissaoNegadaPermanentementeException();
    }

    if (permissao == LocationPermission.denied) {
      throw const PermissaoNegadaException();
    }

    try {
      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: _configuracoes,
      );
      return (latitude: posicao.latitude, longitude: posicao.longitude);
    } on LocationServiceDisabledException {
      throw const ServicoGpsDesativadoException();
    }
  }

  void abrirConfiguracoes() => Geolocator.openAppSettings();

  void abrirConfiguracoesLocalizacao() => Geolocator.openLocationSettings();
}
