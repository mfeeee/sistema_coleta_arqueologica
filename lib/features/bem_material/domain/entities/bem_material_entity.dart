import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';

class BemMaterialEntity {
  final String id;
  final String coletaId;

  final String? codigoIphan;
  final String nomeBem;
  final List<String> nomesPopulares;
  final String natureza;
  final String tipo;
  final String? meiosAcesso;
  final List<ArtefatoBem> artefatos;
  final bool publicado;

  final String? uf;
  final String? municipio;
  final String? cep;
  final String? endereco;
  final double? latitude;
  final double? longitude;
  final String? geojson;

  final int? anoRegistro;
  final String? descricaoAtualizacao;

  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? deletadoEm;

  const BemMaterialEntity({
    required this.id,
    required this.coletaId,
    required this.nomeBem,
    required this.natureza,
    required this.tipo,
    required this.artefatos,
    required this.nomesPopulares,
    required this.publicado,
    required this.criadoEm,
    required this.atualizadoEm,
    this.codigoIphan,
    this.meiosAcesso,
    this.uf,
    this.municipio,
    this.cep,
    this.endereco,
    this.latitude,
    this.longitude,
    this.geojson,
    this.anoRegistro,
    this.descricaoAtualizacao,
    this.deletadoEm,
  });
}
