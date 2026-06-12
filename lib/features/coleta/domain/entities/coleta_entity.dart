import 'package:latlong2/latlong.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/entities/localizacao_entity.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
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
  final LocalizacaoEntity? localizacao;
  final List<ArtefatoTipoEntity> artefatoTipos;
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
    this.localizacao,
    required this.artefatoTipos,
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
    final lat = localizacao?.lat;
    final lng = localizacao?.lng;
    if (lat == null || lng == null) return null;
    return PinoMapa(
      id: id,
      nomeBem: nomeBem,
      posicao: LatLng(lat, lng),
      tipo: TipoPino.coleta,
    );
  }
}
