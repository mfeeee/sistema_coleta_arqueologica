import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

class BemMaterialCacheEntity {
  final String id;
  final String usuarioId;

  final String nome;
  final List<String> nomesPopulares;
  final NaturezaBem natureza;
  final TipoBem tipo;
  final List<ArtefatoBem> artefatos;
  final String? meiosAcesso;
  final List<String> fotoPaths;

  final double latitude;
  final double longitude;

  final String? uf;
  final String? municipio;
  final String? cep;
  final String? endereco;
  final String? geom;

  final String? codigoIphan;

  final StatusColeta syncStatus;
  final int versao;
  final DateTime updatedAt;

  const BemMaterialCacheEntity({
    required this.id,
    required this.usuarioId,
    required this.nome,
    required this.nomesPopulares,
    required this.natureza,
    required this.tipo,
    required this.artefatos,
    required this.fotoPaths,
    required this.latitude,
    required this.longitude,
    required this.syncStatus,
    required this.versao,
    required this.updatedAt,
    this.meiosAcesso,
    this.uf,
    this.municipio,
    this.cep,
    this.endereco,
    this.geom,
    this.codigoIphan,
  });
}
