import 'package:latlong2/latlong.dart';

class SitioMapaEntity {
  final String id;
  final String nomeBem;
  final LatLng posicao;
  final String tipoIcone;

  const SitioMapaEntity({
    required this.id,
    required this.nomeBem,
    required this.posicao,
    required this.tipoIcone,
  });
}
