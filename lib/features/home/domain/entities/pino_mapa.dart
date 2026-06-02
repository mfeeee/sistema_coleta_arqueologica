import 'package:latlong2/latlong.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/tipo_pino.dart';

class PinoMapa {
  final String id;
  final String nomeBem;
  final LatLng posicao;
  final TipoPino tipo;

  const PinoMapa({
    required this.id,
    required this.nomeBem,
    required this.posicao,
    required this.tipo,
  });
}
