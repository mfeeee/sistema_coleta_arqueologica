import 'package:drift/drift.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/artefato_tipo_model.dart';
import 'package:sistema_coleta_arqueologica/core/models/midia_model.dart';

import '../../domain/entities/coleta_entity.dart';

class ColetaModel extends ColetaEntity {
  const ColetaModel({
    required super.id,
    required super.usuarioId,
    required super.dataColeta,
    required super.syncStatus,
    required super.nomeBem,
    super.localizacao,
    required super.artefatoTipos,
    required super.versao,
    required super.updatedAt,
    required super.dadosColetados,
    List<MidiaModel> midias = const [],
    super.natureza,
    super.tipo,
    super.uf,
    super.deletadoEm,
  }) : super(midias: midias);

  @override
  LocalizacaoModel? get localizacao => super.localizacao as LocalizacaoModel?;

  @override
  List<ArtefatoTipoModel> get artefatoTipos =>
      super.artefatoTipos.cast<ArtefatoTipoModel>();

  @override
  List<MidiaModel> get midias => super.midias.cast<MidiaModel>();

  factory ColetaModel.fromRow(Coleta row) {
    final dados = row.dadosColetados;

    // Tenta recuperar localizacao completa dos dados coletados
    LocalizacaoModel? localizacao;
    if (dados['localizacao_completa'] != null) {
      localizacao = LocalizacaoModel.fromJson(
        dados['localizacao_completa'] as Map<String, dynamic>,
      );
    } else {
      final lat = row.latitude == 0.0 ? null : row.latitude;
      final lng = row.longitude == 0.0 ? null : row.longitude;
      localizacao = LocalizacaoModel(
        id: 'local-${row.uuid}',
        uf: row.uf,
        lat: lat,
        lng: lng,
      );
    }

    // Tenta recuperar artefatos completos
    List<ArtefatoTipoModel> artefatos;
    if (dados['artefatos_completos'] != null) {
      artefatos = (dados['artefatos_completos'] as List)
          .map((e) => ArtefatoTipoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      artefatos = row.artefatos
          .map((e) => ArtefatoTipoModel(id: 'tipo-$e', nome: e))
          .toList();
    }

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
      localizacao: localizacao,
      artefatoTipos: artefatos,
      versao: row.versao,
      updatedAt: row.updatedAt,
      dadosColetados: dados,
      midias: [], // Midias are loaded separately or from a joined table
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
      localizacao: entity.localizacao != null
          ? LocalizacaoModel(
              id: entity.localizacao!.id,
              cep: entity.localizacao!.cep,
              logradouro: entity.localizacao!.logradouro,
              municipio: entity.localizacao!.municipio,
              uf: entity.localizacao!.uf,
              lat: entity.localizacao!.lat,
              lng: entity.localizacao!.lng,
            )
          : null,
      artefatoTipos: entity.artefatoTipos
          .map(
            (e) => ArtefatoTipoModel(
              id: e.id,
              nome: e.nome,
              descricaoNova: e.descricaoNova,
              novoTipo: e.novoTipo,
            ),
          )
          .toList(),
      versao: entity.versao,
      updatedAt: entity.updatedAt,
      dadosColetados: entity.dadosColetados,
      midias: entity.midias
          .map(
            (e) => MidiaModel(
              id: e.id,
              mediableType: e.mediableType,
              mediableId: e.mediableId,
              storagePath: e.storagePath,
              mimeType: e.mimeType,
              tipo: e.tipo,
              url: e.url,
              descricao: e.descricao,
            ),
          )
          .toList(),
      deletadoEm: entity.deletadoEm,
    );
  }

  factory ColetaModel.fromJson(Map<String, dynamic> json) {
    // Tenta obter localização de várias fontes (singular ou campos na raiz)
    LocalizacaoModel? localizacao;
    if (json['localizacao'] != null) {
      localizacao = LocalizacaoModel.fromJson(
        json['localizacao'] as Map<String, dynamic>,
      );
    } else if (json['latitude'] != null && json['longitude'] != null) {
      localizacao = LocalizacaoModel(
        id: 'local-${json['uuid'] ?? json['id']}',
        uf: json['uf'] as String?,
        lat: (json['latitude'] as num?)?.toDouble(),
        lng: (json['longitude'] as num?)?.toDouble(),
      );
    }

    return ColetaModel(
      id:
          (json['uuid'] as String?) ??
          (json['id'] as String?) ??
          (throw const FormatException('uuid ausente na coleta')),
      usuarioId:
          (json['usuario_id'] as String?) ??
          (throw const FormatException('usuario_id ausente na coleta')),
      dataColeta:
          DateTime.tryParse(json['data_coleta'] as String? ?? '') ??
          (throw const FormatException('data_coleta inválida')),
      syncStatus: StatusColeta.fromString(
        json['status_sincronizacao'] as String? ?? '',
      ),
      nomeBem: json['nome_bem'] as String? ?? '',
      localizacao: localizacao,
      artefatoTipos:
          (json['artefato_tipos'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => ArtefatoTipoModel.fromJson(e))
              .toList() ??
          [],
      versao: json['versao'] as int? ?? 1,
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
      dadosColetados: json['dados_coletados'] as Map<String, dynamic>? ?? {},
      midias:
          (json['midias'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => MidiaModel.fromJson(e))
              .toList() ??
          [],
      natureza: json['natureza'] != null
          ? NaturezaBem.fromString(json['natureza'] as String)
          : null,
      tipo: json['tipo'] != null
          ? TipoBem.fromString(json['tipo'] as String)
          : null,
      uf: json['uf'] as String?,
      deletadoEm: json['deletado_em'] != null
          ? DateTime.tryParse(json['deletado_em'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'id': id,
      'usuario_id': usuarioId,
      'data_coleta': dataColeta.toIso8601String(),
      'status_sincronizacao': syncStatus.name,
      'nome_bem': nomeBem,
      'localizacao': localizacao?.toJson(),
      'latitude': localizacao?.lat,
      'longitude': localizacao?.lng,
      'artefato_tipos': artefatoTipos.map((e) => e.toJson()).toList(),
      'versao': versao,
      'updated_at': updatedAt.toIso8601String(),
      'dados_coletados': dadosColetados,
      'midias': midias.map((e) => e.toJson()).toList(),
      'natureza': natureza?.name,
      'tipo': tipo?.name,
      'uf': uf,
      'deletado_em': deletadoEm?.toIso8601String(),
    };
  }

  ColetasCompanion toCompanion() {
    final novosDados = Map<String, dynamic>.from(dadosColetados);

    if (localizacao != null) {
      novosDados['localizacao_completa'] = localizacao!.toJson();
    }
    novosDados['artefatos_completos'] = artefatoTipos
        .map((e) => e.toJson())
        .toList();

    return ColetasCompanion.insert(
      uuid: id,
      usuarioId: usuarioId,
      dataColeta: Value(dataColeta),
      statusSincronizacao: Value(syncStatus),
      nomeBem: Value(nomeBem),
      natureza: Value(natureza?.name),
      tipo: Value(tipo?.name),
      uf: Value(localizacao?.uf),
      latitude: Value(localizacao?.lat),
      longitude: Value(localizacao?.lng),
      artefatos: Value(artefatoTipos.map((e) => e.nome).toList()),
      versao: Value(versao),
      updatedAt: Value(updatedAt),
      dadosColetados: novosDados,
      deletadoEm: Value(deletadoEm),
    );
  }
}
