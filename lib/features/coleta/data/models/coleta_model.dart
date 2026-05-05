import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';

import '../../domain/entities/coleta_entity.dart';
import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

class ColetaModel extends ColetaEntity {
  const ColetaModel({
    required super.id,
    required super.usuarioId,
    required super.dataColeta,
    required super.syncStatus,
    required super.nomeBem,
    required super.latitude,
    required super.longitude,
    required super.artefatos,
    required super.versao,
    required super.updatedAt,
    required super.dadosColetados,
    super.natureza,
    super.tipo,
    super.uf,
    super.deletadoEm,
  });

  factory ColetaModel.fromRow(Coleta row) {
    return ColetaModel(
      id: row.uuid,
      usuarioId: row.usuarioId,
      dataColeta: row.dataColeta,
      syncStatus: row.statusSincronizacao,
      nomeBem: row.nomeBem,
      natureza: row.natureza != null
          ? NaturezaBem.values.firstWhere(
              (e) => e.name == row.natureza,
              orElse: () => NaturezaBem.bemArqueologico,
            )
          : null,
      tipo: row.tipo != null
          ? TipoBem.values.firstWhere(
              (e) => e.name == row.tipo,
              orElse: () => TipoBem.sitio,
            )
          : null,
      uf: row.uf,
      latitude: row.latitude,
      longitude: row.longitude,
      artefatos: row.artefatos
          .map((e) => ArtefatoBem.values.byName(e))
          .toList(),
      versao: row.versao,
      updatedAt: row.updatedAt,
      dadosColetados: row.dadosColetados,
      deletadoEm: row.deletadoEm,
    );
  }

  factory ColetaModel.fromEntity(ColetaEntity entity) {
    return ColetaModel(
      id: entity.id,
      usuarioId: entity.usuarioId,
      dataColeta: entity.dataColeta,
      syncStatus: entity.syncStatus,
      nomeBem: entity.nomeBem,
      natureza: entity.natureza,
      tipo: entity.tipo,
      uf: entity.uf,
      latitude: entity.latitude,
      longitude: entity.longitude,
      artefatos: entity.artefatos,
      versao: entity.versao,
      updatedAt: entity.updatedAt,
      dadosColetados: entity.dadosColetados,
      deletadoEm: entity.deletadoEm,
    );
  }

  factory ColetaModel.fromJson(Map<String, dynamic> json) {
    return ColetaModel(
      id: json['uuid'] as String,
      usuarioId: json['usuario_id'] as String,
      dataColeta: DateTime.parse(json['data_coleta'] as String),
      syncStatus: StatusColeta.values.byName(
        json['status_sincronizacao'] as String? ?? StatusColeta.pendente.name,
      ),
      nomeBem: json['nome_bem'] as String? ?? '',
      natureza: json['natureza'] != null
          ? NaturezaBem.values.firstWhere(
              (e) => e.name == json['natureza'],
              orElse: () => NaturezaBem.bemArqueologico,
            )
          : null,
      tipo: json['tipo'] != null
          ? TipoBem.values.firstWhere(
              (e) => e.name == json['tipo'],
              orElse: () => TipoBem.sitio,
            )
          : null,
      uf: json['uf'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      artefatos: (json['artefatos'] as List<dynamic>?)
              ?.map((e) => ArtefatoBem.values.byName(e as String))
              .toList() ??
          [],
      versao: json['versao'] as int? ?? 1,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      dadosColetados:
          json['dados_coletados'] as Map<String, dynamic>? ?? {},
      deletadoEm: json['deletado_em'] != null
          ? DateTime.tryParse(json['deletado_em'] as String)
          : null,
    );
  }

  ColetasCompanion toCompanion() {
    return ColetasCompanion.insert(
      uuid: id,
      usuarioId: usuarioId,
      dataColeta: Value(dataColeta),
      statusSincronizacao: Value(syncStatus),
      nomeBem: Value(nomeBem),
      natureza: Value(natureza?.name),
      tipo: Value(tipo?.name),
      uf: Value(uf),
      latitude: Value(latitude),
      longitude: Value(longitude),
      artefatos: Value(artefatos.map((e) => e.name).toList()),
      versao: Value(versao),
      updatedAt: Value(updatedAt),
      dadosColetados: dadosColetados,
      deletadoEm: Value(deletadoEm),
    );
  }
}