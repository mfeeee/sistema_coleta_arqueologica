import 'dart:math' as math;
import '../entities/coleta_entity.dart';
import '../repositories/coleta_repository.dart';

class ProximidadeService {
  final ColetaRepository _repository;

  ProximidadeService(this._repository);

  /// Varre o banco offline em busca de sítios próximos à coordenada dada.
  Future<List<ColetaEntity>> buscarBemMaterialsProximos({
    required double latAtual,
    required double lonAtual,
    double raioMetros = 500.0,
  }) async {
    // TODO: Melhorar a complexidade de tempo inserindo queries espaciais.
    final coletas = await _repository.getAll();

    final sitiosProximos = <ColetaEntity>[];

    for (final sitio in coletas) {
      final distancia = _calcularDistancia(
        latAtual,
        lonAtual,
        sitio.latitude,
        sitio.longitude,
      );

      if (distancia <= raioMetros) {
        sitiosProximos.add(sitio);
      }
    }

    return sitiosProximos;
  }

  /// Fórmula de Haversine
  double _calcularDistancia(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double raioTerra = 6371000;
    final double dLat = _grausParaRadianos(lat2 - lat1);
    final double dLon = _grausParaRadianos(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_grausParaRadianos(lat1)) *
            math.cos(_grausParaRadianos(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return raioTerra * c;
  }

  double _grausParaRadianos(double graus) {
    return graus * math.pi / 180;
  }
}
