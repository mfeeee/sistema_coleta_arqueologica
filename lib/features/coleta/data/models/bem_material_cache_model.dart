import '../../domain/entities/bem_material_cache_entity.dart';
import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

class BemMaterialCacheModel extends BemMaterialCacheEntity {
  final String usuarioId;
  final StatusColeta syncStatus;
  final int versao;
  final DateTime updatedAt;

  const BemMaterialCacheModel({
    required super.id,
    required super.nome,
    required super.latitude,
    required super.longitude,
    required this.usuarioId,
    required this.syncStatus,
    required this.versao,
    required this.updatedAt,
  });

  factory BemMaterialCacheModel.fromColetaData(Coleta row) {
    final dados = row.dadosColetados;
    return BemMaterialCacheModel(
      id: row.uuid,
      nome: dados['nome'] as String? ?? '',
      latitude: (dados['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (dados['longitude'] as num?)?.toDouble() ?? 0.0,
      usuarioId: row.usuarioId,
      syncStatus: row.statusSincronizacao,
      versao: row.versao,
      updatedAt: row.updatedAt,
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
      nome: json['nome'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      usuarioId: json['usuario_id'] as String? ?? '',
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
