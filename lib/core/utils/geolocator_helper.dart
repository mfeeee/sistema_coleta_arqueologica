// import 'package:geolocator/geolocator.dart';

typedef Coordenada = ({double latitude, double longitude});

class GeolocatorHelper {

  Future<Coordenada> obterCoordenadaAtual() async {
    await Future.delayed(const Duration(seconds: 2));
    return (latitude: -8.8475, longitude: -42.5480);
  }
}