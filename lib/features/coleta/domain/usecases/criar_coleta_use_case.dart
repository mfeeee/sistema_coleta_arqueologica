import 'package:uuid/uuid.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/entities/localizacao_entity.dart';
import 'package:sistema_coleta_arqueologica/core/entities/artefato_tipo_entity.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_material_entity.dart';
import '../entities/coleta_entity.dart';

class ColetaFormResult {
  final ColetaEntity coleta;
  final BemMaterialEntity bemMaterial;
  const ColetaFormResult({required this.coleta, required this.bemMaterial});
}

class CriarColetaInput {
  final String nome;
  final List<String> nomesPopulares;
  final NaturezaBem? natureza;
  final TipoBem? tipo;
  final List<ArtefatoBem> artefatos;
  final String? meiosAcesso;
  final List<String> fotoPaths;
  final double lat;
  final double lng;
  final String usuarioId;

  const CriarColetaInput({
    required this.nome,
    required this.nomesPopulares,
    required this.artefatos,
    required this.fotoPaths,
    required this.lat,
    required this.lng,
    required this.usuarioId,
    this.natureza,
    this.tipo,
    this.meiosAcesso,
  });
}

class CriarColetaUseCase {
  const CriarColetaUseCase();

  ColetaFormResult call(CriarColetaInput input) {
    final coletaId = const Uuid().v4();
    final agora = DateTime.now();

    final localizacao = LocalizacaoEntity(
      id: const Uuid().v4(),
      lat: input.lat,
      lng: input.lng,
    );

    final artefatoTipos = input.artefatos
        .map((e) => ArtefatoTipoEntity(id: const Uuid().v4(), nome: e.name))
        .toList();

    final coleta = ColetaEntity(
      id: coletaId,
      usuarioId: input.usuarioId,
      dataColeta: agora,
      syncStatus: StatusColeta.pendente,
      nomeBem: input.nome.trim(),
      natureza: input.natureza,
      tipo: input.tipo,
      localizacao: localizacao,
      artefatoTipos: artefatoTipos,
      versao: 1,
      updatedAt: agora,
      dadosColetados: {
        'nomes_populares': input.nomesPopulares,
        'meios_acesso': input.meiosAcesso,
        'foto_paths': input.fotoPaths,
      },
    );

    final bemMaterial = BemMaterialEntity(
      id: const Uuid().v4(),
      coletaId: coletaId,
      nomeBem: input.nome.trim(),
      nomesPopulares: input.nomesPopulares,
      natureza: input.natureza?.name,
      tipo: input.tipo?.name,
      meiosAcesso: input.meiosAcesso?.trim(),
      artefatoTipos: artefatoTipos,
      responsaveis: const [],
      publicado: false,
      criadoEm: agora,
      atualizadoEm: agora,
      localizacao: localizacao,
    );

    return ColetaFormResult(coleta: coleta, bemMaterial: bemMaterial);
  }

  ColetaEntity criarRascunho(CriarColetaInput input) {
    final agora = DateTime.now();

    final localizacao = LocalizacaoEntity(
      id: const Uuid().v4(),
      lat: input.lat,
      lng: input.lng,
    );

    final artefatoTipos = input.artefatos
        .map((e) => ArtefatoTipoEntity(id: const Uuid().v4(), nome: e.name))
        .toList();

    return ColetaEntity(
      id: const Uuid().v4(),
      usuarioId: input.usuarioId,
      dataColeta: agora,
      syncStatus: StatusColeta.rascunho,
      nomeBem: input.nome.trim().isEmpty ? 'Rascunho' : input.nome.trim(),
      natureza: input.natureza,
      tipo: input.tipo,
      localizacao: localizacao,
      artefatoTipos: artefatoTipos,
      versao: 1,
      updatedAt: agora,
      dadosColetados: {
        'nomes_populares': input.nomesPopulares,
        'meios_acesso': input.meiosAcesso,
        'foto_paths': input.fotoPaths,
      },
    );
  }
}
