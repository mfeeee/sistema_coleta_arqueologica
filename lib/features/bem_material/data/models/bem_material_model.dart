import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import '../../domain/entities/bem_material_entity.dart';

class BemMaterialModel extends BemMaterialEntity {
  const BemMaterialModel({
    required super.id,
    required super.coletaId,
    required super.nomeBem,
    required super.natureza,
    required super.tipo,
    required super.artefatos,
    required super.nomesPopulares,
    required super.publicado,
    required super.criadoEm,
    required super.atualizadoEm,
    super.codigoIphan,
    super.meiosAcesso,
    super.uf,
    super.municipio,
    super.cep,
    super.endereco,
    super.latitude,
    super.longitude,
    super.geojson,
    super.anoRegistro,
    super.descricaoAtualizacao,
    super.deletadoEm,
  });

  factory BemMaterialModel.fromRow(BensMateriai row) {
    return BemMaterialModel(
      id: row.uuid,
      coletaId: row.coletaId,
      codigoIphan: row.codigoIphan,
      nomeBem: row.nomeBem,
      nomesPopulares: row.nomesPopulares != null
          ? row.nomesPopulares!.split(',').map((e) => e.trim()).toList()
          : [],
      natureza: row.natureza,
      tipo: row.tipo,
      meiosAcesso: row.meiosAcesso,
      artefatos: row.artefatos
          .map((e) => ArtefatoBem.values.byName(e))
          .toList(),
      publicado: row.publicado,
      uf: row.uf,
      municipio: row.municipio,
      cep: row.cep,
      endereco: row.endereco,
      latitude: row.latitude,
      longitude: row.longitude,
      geojson: row.geojson,
      anoRegistro: row.anoRegistro,
      descricaoAtualizacao: row.descricaoAtualizacao,
      criadoEm: row.criadoEm,
      atualizadoEm: row.atualizadoEm,
      deletadoEm: row.deletadoEm,
    );
  }

  factory BemMaterialModel.fromEntity(BemMaterialEntity entity) {
    return BemMaterialModel(
      id: entity.id,
      coletaId: entity.coletaId,
      codigoIphan: entity.codigoIphan,
      nomeBem: entity.nomeBem,
      nomesPopulares: entity.nomesPopulares,
      natureza: entity.natureza,
      tipo: entity.tipo,
      meiosAcesso: entity.meiosAcesso,
      artefatos: entity.artefatos,
      publicado: entity.publicado,
      uf: entity.uf,
      municipio: entity.municipio,
      cep: entity.cep,
      endereco: entity.endereco,
      latitude: entity.latitude,
      longitude: entity.longitude,
      geojson: entity.geojson,
      anoRegistro: entity.anoRegistro,
      descricaoAtualizacao: entity.descricaoAtualizacao,
      criadoEm: entity.criadoEm,
      atualizadoEm: entity.atualizadoEm,
      deletadoEm: entity.deletadoEm,
    );
  }

  factory BemMaterialModel.fromJson(Map<String, dynamic> json) {
    return BemMaterialModel(
      id: json['uuid'] as String,
      coletaId: json['coleta_id'] as String,
      codigoIphan: json['codigo_iphan'] as String?,
      nomeBem: json['nome_bem'] as String,
      nomesPopulares:
          (json['nomes_populares'] as List<dynamic>?)?.cast<String>() ?? [],
      natureza: json['natureza'] as String,
      tipo: json['tipo'] as String,
      meiosAcesso: json['meios_acesso'] as String?,
      artefatos:
          (json['artefatos'] as List<dynamic>?)
              ?.map((e) => ArtefatoBem.values.byName(e as String))
              .toList() ??
          [],
      publicado: json['publicado'] as bool? ?? false,
      uf: json['uf'] as String?,
      municipio: json['municipio'] as String?,
      cep: json['cep'] as String?,
      endereco: json['endereco'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      geojson: json['geojson'] as String?,
      anoRegistro: json['ano_registro'] as int?,
      descricaoAtualizacao: json['descricao_atualizacao'] as String?,
      criadoEm: DateTime.parse(json['criado_em'] as String),
      atualizadoEm: DateTime.parse(json['atualizado_em'] as String),
      deletadoEm: json['deletado_em'] != null
          ? DateTime.tryParse(json['deletado_em'] as String)
          : null,
    );
  }

  BensMateriaisCompanion toCompanion() {
    return BensMateriaisCompanion.insert(
      uuid: id,
      coletaId: coletaId,
      nomeBem: nomeBem,
      natureza: natureza,
      tipo: tipo,
      artefatos: Value(artefatos.map((e) => e.name).toList()),
      publicado: Value(publicado),
      codigoIphan: Value(codigoIphan),
      nomesPopulares: Value(nomesPopulares.join(', ')),
      meiosAcesso: Value(meiosAcesso),
      uf: Value(uf),
      municipio: Value(municipio),
      cep: Value(cep),
      endereco: Value(endereco),
      latitude: Value(latitude),
      longitude: Value(longitude),
      geojson: Value(geojson),
      anoRegistro: Value(anoRegistro),
      descricaoAtualizacao: Value(descricaoAtualizacao),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
      deletadoEm: Value(deletadoEm),
    );
  }
}
