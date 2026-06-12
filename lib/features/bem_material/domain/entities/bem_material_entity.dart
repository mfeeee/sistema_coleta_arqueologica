import 'package:latlong2/latlong.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import 'package:sistema_coleta_arqueologica/core/entities/localizacao_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_responsavel_entity.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/pino_mapa.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/tipo_pino.dart';

class BemMaterialEntity {
  final String id;
  final String? coletaId;
  final String? curadorResponsavelId;

  final String? codigoIphan;
  final String nomeBem;
  final List<String> nomesPopulares;
  final String? natureza;
  final String? tipo;
  final String? meiosAcesso;
  final List<ArtefatoTipoEntity> artefatoTipos;
  final List<BemResponsavelEntity> responsaveis;
  final bool publicado;

  final LocalizacaoEntity? localizacao;
  final String? geojson;

  final int? anoRegistro;
  final String? descricaoAtualizacao;

  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? deletadoEm;

  const BemMaterialEntity({
    required this.id,
    required this.nomeBem,
    this.natureza,
    this.tipo,
    required this.artefatoTipos,
    required this.responsaveis,
    required this.nomesPopulares,
    required this.publicado,
    required this.criadoEm,
    required this.atualizadoEm,
    this.localizacao,
    this.coletaId,
    this.curadorResponsavelId,
    this.codigoIphan,
    this.meiosAcesso,
    this.geojson,
    this.anoRegistro,
    this.descricaoAtualizacao,
    this.deletadoEm,
  });
}

extension BemParaMapa on BemMaterialEntity {
  PinoMapa? get paraMapa {
    final lat = localizacao?.lat;
    final lng = localizacao?.lng;
    if (lat == null || lng == null) return null;
    if (lat < -90.0 || lat > 90.0 || lng < -180.0 || lng > 180.0) return null;
    if (lat == 0.0 && lng == 0.0) return null;
    return PinoMapa(
      id: id,
      nomeBem: nomeBem,
      posicao: LatLng(lat, lng),
      tipo: TipoPino.bemPublicado,
    );
  }
}
