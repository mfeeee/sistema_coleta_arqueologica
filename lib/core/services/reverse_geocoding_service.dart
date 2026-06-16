import 'dart:developer' as developer;
import 'package:geocoding/geocoding.dart';

import '../models/localizacao_model.dart';

class ReverseGeocodingService {
  Future<LocalizacaoModel?> fromCoords(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        return LocalizacaoModel(
          id: '',
          cep: place.postalCode ?? '',
          logradouro: place.street ?? '',
          municipio: place.subAdministrativeArea ?? place.locality ?? '',
          uf: place.administrativeArea ?? '',
          lat: lat,
          lng: lng,
        );
      }

      return null;
    } catch (e, stackTrace) {
      developer.log(
        'Erro ao realizar geocodificação reversa para ($lat, $lng)',
        name: 'ReverseGeocodingService',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
