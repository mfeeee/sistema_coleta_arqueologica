import 'package:latlong2/latlong.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/pino_mapa.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/tipo_pino.dart';

// Invariante: syncStatus é a única fonte de verdade para o estado de
// sincronização. Não existe campo booleano `sincronizado` paralelo.
class ColetaEntity {
  final String id;
  final String usuarioId;
  final DateTime dataColeta;
  final StatusColeta syncStatus;
  final String nomeBem;
  final NaturezaBem? natureza;
  final TipoBem? tipo;
  final String? uf;
  final double? latitude;
  final double? longitude;
  final List<ArtefatoBem> artefatos;
  final int versao;
  final DateTime updatedAt;
  final Map<String, dynamic> dadosColetados;
  final List<String> fotosUrls;
  final DateTime? deletadoEm;

  const ColetaEntity({
    required this.id,
    required this.usuarioId,
    required this.dataColeta,
    required this.syncStatus,
    required this.nomeBem,
    this.latitude,
    this.longitude,
    required this.artefatos,
    required this.versao,
    required this.updatedAt,
    required this.dadosColetados,
    this.fotosUrls = const [],
    this.natureza,
    this.tipo,
    this.uf,
    this.deletadoEm,
  });
}

extension ColetaParaMapa on ColetaEntity {
  PinoMapa? get paraMapa {
    final lat = latitude;
    final lng = longitude;
    if (lat == null || lng == null) return null;
    return PinoMapa(
      id: id,
      nomeBem: nomeBem,
      posicao: LatLng(lat, lng),
      tipo: TipoPino.coleta,
    );
  }
}
