import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/models/artefato_tipo_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/bem_responsavel_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/usuario_model.dart';
import '../../domain/entities/bem_material_entity.dart';

class BemMaterialModel extends BemMaterialEntity {
  const BemMaterialModel({
    required super.id,
    required super.nomeBem,
    super.natureza,
    super.tipo,
    required super.artefatoTipos,
    required super.responsaveis,
    required super.nomesPopulares,
    required super.publicado,
    required super.criadoEm,
    required super.atualizadoEm,
    super.localizacao,
    super.coletaId,
    super.curadorResponsavelId,
    super.codigoIphan,
    super.meiosAcesso,
    super.geojson,
    super.anoRegistro,
    super.descricaoAtualizacao,
    super.deletadoEm,
  });

  factory BemMaterialModel.fromRow(BensMateriai row) {
    return BemMaterialModel(
      id: row.uuid,
      coletaId: row.coletaId,
      curadorResponsavelId: row.curadorResponsavelId,
      codigoIphan: row.codigoIphan,
      nomeBem: row.nomeBem,
      nomesPopulares: row.nomesPopulares != null
          ? row.nomesPopulares!.split(',').map((e) => e.trim()).toList()
          : [],
      natureza: row.natureza,
      tipo: row.tipo,
      meiosAcesso: row.meiosAcesso,
      artefatoTipos: row.artefatos
          .map((e) => ArtefatoTipoModel(id: e, nome: e))
          .toList(),
      responsaveis: [],
      publicado: row.publicado,
      localizacao: row.uf != null ||
              row.municipio != null ||
              row.latitude != null ||
              row.longitude != null
          ? LocalizacaoModel(
              id: '${row.uuid}_loc',
              uf: row.uf,
              municipio: row.municipio,
              cep: row.cep,
              logradouro: row.endereco,
              lat: _parseDouble(row.latitude),
              lng: _parseDouble(row.longitude),
            )
          : null,
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
      curadorResponsavelId: entity.curadorResponsavelId,
      codigoIphan: entity.codigoIphan,
      nomeBem: entity.nomeBem,
      nomesPopulares: entity.nomesPopulares,
      natureza: entity.natureza,
      tipo: entity.tipo,
      meiosAcesso: entity.meiosAcesso,
      artefatoTipos: entity.artefatoTipos
          .map((e) => ArtefatoTipoModel(
                id: e.id,
                nome: e.nome,
                descricaoNova: e.descricaoNova,
                novoTipo: e.novoTipo,
              ))
          .toList(),
      responsaveis: entity.responsaveis
          .map((e) => BemResponsavelModel(
                usuarioModel: UsuarioModel(
                  id: e.usuario.id,
                  nome: e.usuario.nome,
                  email: e.usuario.email,
                  avatarUrl: e.usuario.avatarUrl,
                ),
                papel: e.papel,
              ))
          .toList(),
      publicado: entity.publicado,
      localizacao: entity.localizacao != null
          ? LocalizacaoModel(
              id: entity.localizacao!.id,
              uf: entity.localizacao!.uf,
              municipio: entity.localizacao!.municipio,
              cep: entity.localizacao!.cep,
              logradouro: entity.localizacao!.logradouro,
              lat: entity.localizacao!.lat,
              lng: entity.localizacao!.lng,
            )
          : null,
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

  factory BemMaterialModel.fromJson(Map<String, dynamic> json) {
    return BemMaterialModel(
      id: json['id'] as String,
      coletaId: json['coleta_id'] as String?,
      curadorResponsavelId: json['curador_responsavel_id'] as String?,
      codigoIphan: json['codigo_iphan'] as String?,
      nomeBem: json['nome_bem'] as String,
      nomesPopulares: json['nomes_populares'] is List
          ? (json['nomes_populares'] as List).cast<String>()
          : [],
      natureza: json['natureza'] as String?,
      tipo: json['tipo'] as String?,
      meiosAcesso: json['meios_acesso'] as String?,
      artefatoTipos: json['artefato_tipos'] is List
          ? (json['artefato_tipos'] as List)
              .map((e) => ArtefatoTipoModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      responsaveis: json['responsaveis'] is List
          ? (json['responsaveis'] as List)
              .map((e) => BemResponsavelModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      publicado: json['publicado'] as bool? ?? false,
      localizacao: json['localizacao'] != null
          ? LocalizacaoModel.fromJson(json['localizacao'] as Map<String, dynamic>)
          : null,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coleta_id': coletaId,
      'curador_responsavel_id': curadorResponsavelId,
      'codigo_iphan': codigoIphan,
      'nome_bem': nomeBem,
      'nomes_populares': nomesPopulares,
      'natureza': natureza,
      'tipo': tipo,
      'meios_acesso': meiosAcesso,
      'artefato_tipos': artefatoTipos
          .map((e) => (e as ArtefatoTipoModel).toJson())
          .toList(),
      'responsaveis': responsaveis
          .map((e) => (e as BemResponsavelModel).toJson())
          .toList(),
      'publicado': publicado,
      'localizacao': (localizacao as LocalizacaoModel?)?.toJson(),
      'geojson': geojson,
      'ano_registro': anoRegistro,
      'descricao_atualizacao': descricaoAtualizacao,
      'created_at': criadoEm.toIso8601String(),
      'updated_at': atualizadoEm.toIso8601String(),
      'deleted_at': deletadoEm?.toIso8601String(),
    };
  }

  BensMateriaisCompanion toCompanion() {
    return BensMateriaisCompanion.insert(
      uuid: id,
      coletaId: Value(coletaId),
      curadorResponsavelId: Value(curadorResponsavelId),
      nomeBem: nomeBem,
      natureza: Value(natureza),
      tipo: Value(tipo),
      artefatos: Value(artefatoTipos.map((e) => e.nome).toList()),
      publicado: Value(publicado),
      codigoIphan: Value(codigoIphan),
      nomesPopulares: Value(nomesPopulares.join(', ')),
      meiosAcesso: Value(meiosAcesso),
      uf: Value(localizacao?.uf),
      municipio: Value(localizacao?.municipio),
      cep: Value(localizacao?.cep),
      endereco: Value(localizacao?.logradouro),
      latitude: Value(localizacao?.lat?.toStringAsFixed(7)),
      longitude: Value(localizacao?.lng?.toStringAsFixed(7)),
      geojson: Value(geojson),
      anoRegistro: Value(anoRegistro),
      descricaoAtualizacao: Value(descricaoAtualizacao),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
      deletadoEm: Value(deletadoEm),
    );
  }
}
