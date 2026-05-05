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
    super.meiosAcesso,
    super.uf,
    super.municipio,
    super.cep,
    super.endereco,
    super.geom,
    super.codigoIphan,
  });

  factory ColetaModel.fromColetaData(Coleta row) {
    final dados = row.dadosColetados;
    return ColetaModel(
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
      artefatos:
          (dados['artefatos'] as List<dynamic>?)
              ?.map((e) => ArtefatoBem.values.byName(e as String))
              .toList() ??
          [],
      uf: dados['uf'] as String?,
      municipio: dados['municipio'] as String?,
      cep: dados['cep'] as String?,
      endereco: dados['endereco'] as String?,
      codigoIphan: dados['codigo_iphan'] as String?,
      meiosAcesso: dados['meios_acesso'] as String?,
      fotoPaths: (dados['foto_paths'] as List?)?.cast<String>() ?? [],
      syncStatus: row.statusSincronizacao,
      versao: row.versao,
      updatedAt: row.updatedAt,
    );
  }

  factory ColetaModel.fromEntity(ColetaEntity entity) {
    return ColetaModel(
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
      meiosAcesso: entity.meiosAcesso,
      uf: entity.uf,
      municipio: entity.municipio,
      cep: entity.cep,
      endereco: entity.endereco,
      geom: entity.geom,
      codigoIphan: entity.codigoIphan,
    );
  }

  ColetasCompanion toCompanion() {
    return ColetasCompanion.insert(
      uuid: id,
      usuarioId: usuarioId,
      nomeBem: Value(nome),
      natureza: Value(natureza.name),
      tipo: Value(tipo.name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      artefatos: Value(artefatos.map((e) => e.name).toList()),
      statusSincronizacao: Value(syncStatus),
      versao: Value(versao),
      updatedAt: Value(updatedAt),
      dadosColetados: {
        'nome': nome,
        'nomes_populares': nomesPopulares,
        'natureza': natureza.name,
        'tipo': tipo.name,
        'latitude': latitude,
        'longitude': longitude,
        'artefatos': artefatos.map((e) => e.name).toList(),
        'foto_paths': fotoPaths,
        'meios_acesso': meiosAcesso,
        'uf': uf,
        'municipio': municipio,
        'cep': cep,
        'endereco': endereco,
        'codigo_iphan': codigoIphan,
      },
    );
  }

  factory ColetaModel.fromJson(Map<String, dynamic> json) {
    return ColetaModel(
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
      artefatos:
          (json['artefatos'] as List<dynamic>?)
              ?.map((e) => ArtefatoBem.values.byName(e as String))
              .toList() ??
          [],
      fotoPaths: (json['foto_paths'] as List?)?.cast<String>() ?? [],
      syncStatus: StatusColeta.values.byName(
        json['sync_status'] as String? ?? StatusColeta.pendente.name,
      ),
      versao: json['versao'] as int? ?? 1,
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
      meiosAcesso: json['meios_acesso'] as String?,
      uf: json['uf'] as String?,
      municipio: json['municipio'] as String?,
      cep: json['cep'] as String?,
      endereco: json['endereco'] as String?,
      codigoIphan: json['codigo_iphan'] as String?,
    );
  }
}
