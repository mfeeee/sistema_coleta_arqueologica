import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';

import '../../domain/entities/bem_material_cache_entity.dart';
import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

class BemMaterialCacheModel extends BemMaterialCacheEntity {
  const BemMaterialCacheModel({
    required super.id,
    required super.usuarioId,
    required super.nome,
    required super.nomesPopulares,
    required super.natureza,
    required super.tipo,
    required super.artefatos,
    required super.fotoPaths,
    required super.latitude,
    required super.longitude,
    required super.syncStatus,
    required super.versao,
    required super.updatedAt,
  });

  factory BemMaterialCacheModel.fromColetaData(Coleta row) {
    final dados = row.dadosColetados;
    return BemMaterialCacheModel(
      id: row.uuid,
      usuarioId: row.usuarioId,
      nome: dados['nome'] as String? ?? '',
      nomesPopulares: (dados['nomes_populares'] as List?)?.cast<String>() ?? [],
      natureza: NaturezaBem.values.firstWhere(
        (e) => e.name == (dados['natureza'] as String? ?? ''),
        orElse: () => NaturezaBem.bemArqueologico,
      ),
      tipo: TipoBem.values.firstWhere(
        (e) => e.name == (dados['tipo'] as String? ?? ''),
        orElse: () => TipoBem.sitio,
      ),
      latitude: (dados['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (dados['longitude'] as num?)?.toDouble() ?? 0.0,
      artefatos: (dados['artefatos'] as List?)?.cast<ArtefatoBem>() ?? [],
      fotoPaths: (dados['foto_paths'] as List?)?.cast<String>() ?? [],
      syncStatus: row.statusSincronizacao,
      versao: row.versao,
      updatedAt: row.updatedAt,
    );
  }

  factory BemMaterialCacheModel.fromEntity(BemMaterialCacheEntity entity) {
    return BemMaterialCacheModel(
      id: entity.id,
      usuarioId: entity.usuarioId,
      nome: entity.nome,
      nomesPopulares: entity.nomesPopulares,
      natureza: entity.natureza,
      tipo: entity.tipo,
      artefatos: entity.artefatos,
      fotoPaths: entity.fotoPaths,
      latitude: entity.latitude,
      longitude: entity.longitude,
      syncStatus: entity.syncStatus,
      versao: entity.versao,
      updatedAt: entity.updatedAt,
    );
  }

  ColetasCompanion toCompanion() {
    return ColetasCompanion.insert(
      uuid: id,
      usuarioId: usuarioId,
      dadosColetados: {
        'nome': nome,
        'latitude': latitude,
        'longitude': longitude,
      },
      statusSincronizacao: Value(syncStatus),
      versao: Value(versao),
      updatedAt: Value(updatedAt),
    );
  }

  factory BemMaterialCacheModel.fromJson(Map<String, dynamic> json) {
    return BemMaterialCacheModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String? ?? '',
      nome: json['nome'] as String,
      nomesPopulares: (json['nomes_populares'] as List?)?.cast<String>() ?? [],
      natureza: NaturezaBem.values.firstWhere(
        (e) => e.name == (json['natureza'] as String? ?? ''),
        orElse: () => NaturezaBem.bemArqueologico,
      ),
      tipo: TipoBem.values.firstWhere(
        (e) => e.name == (json['tipo'] as String? ?? ''),
        orElse: () => TipoBem.sitio,
      ),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      artefatos: (json['artefatos'] as List?)?.cast<ArtefatoBem>() ?? [],
      fotoPaths: (json['foto_paths'] as List?)?.cast<String>() ?? [],
      syncStatus: StatusColeta.values.byName(
        json['sync_status'] as String? ?? StatusColeta.pendente.name,
      ),
      versao: json['versao'] as int? ?? 1,
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
