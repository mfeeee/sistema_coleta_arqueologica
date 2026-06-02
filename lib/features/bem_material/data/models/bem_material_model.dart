import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import '../../domain/entities/bem_material_entity.dart';

class BemMaterialModel extends BemMaterialEntity {
  const BemMaterialModel({
    required super.id,
    required super.nomeBem,
    required super.natureza,
    required super.tipo,
    required super.artefatos,
    required super.nomesPopulares,
    required super.publicado,
    required super.criadoEm,
    required super.atualizadoEm,
    super.coletaId,
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
          .map((e) {
            try {
              return ArtefatoBem.values.byName(e);
            } catch (_) {
              log(
                'fromRow: artefato desconhecido "$e" — ignorando',
                name: 'BemMaterialModel',
              );
              return null;
            }
          })
          .whereType<ArtefatoBem>()
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

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) return value.cast<String>();
    if (value is String && value.isNotEmpty) {
      return value.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }

  static List<ArtefatoBem> _parseArtefatos(dynamic value) {
    late final List<dynamic> list;
    if (value is List) {
      list = value;
    } else if (value is String && value.isNotEmpty) {
      final decoded = jsonDecode(value);
      list = decoded is List ? decoded : [];
    } else {
      return [];
    }
    return list
        .map((e) {
          final nome = e is Map ? e['value'] as String? : e as String?;
          if (nome == null) return null;
          try {
            return ArtefatoBem.values.byName(nome);
          } catch (_) {
            return null;
          }
        })
        .whereType<ArtefatoBem>()
        .toList();
  }

  factory BemMaterialModel.fromJson(Map<String, dynamic> json) {
    String enumStr(dynamic value) {
      if (value is Map) return (value['value'] as String?) ?? '';
      return value as String? ?? '';
    }

    return BemMaterialModel(
      id: json['id'] as String,
      coletaId: json['coleta_id'] as String?,
      codigoIphan: json['codigo_iphan'] as String?,
      nomeBem: json['nome_bem'] as String,
      nomesPopulares: _parseStringList(json['nomes_populares']),
      natureza: enumStr(json['natureza']),
      tipo: enumStr(json['tipo']),
      meiosAcesso: json['meios_acesso'] as String?,
      artefatos: _parseArtefatos(json['artefatos']),
      publicado: json['publicado'] as bool? ?? false,
      uf: json['uf'] as String?,
      municipio: json['municipio'] as String?,
      cep: json['cep'] as String?,
      endereco: json['endereco'] as String?,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      geojson: json['geojson'] is String
          ? json['geojson'] as String
          : json['geojson'] != null
          ? jsonEncode(json['geojson'])
          : null,
      anoRegistro: json['ano_registro'] as int?,
      descricaoAtualizacao: json['descricao_atualizacao'] as String?,
      criadoEm: DateTime.parse(json['created_at'] as String),
      atualizadoEm: DateTime.parse(json['updated_at'] as String),
      deletadoEm: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
    );
  }

  BensMateriaisCompanion toCompanion() {
    return BensMateriaisCompanion.insert(
      uuid: id,
      coletaId: coletaId ?? '',
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
