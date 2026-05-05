import '../../domain/entities/coleta_entity.dart';
import '../../domain/repositories/coleta_repository.dart';
import '../datasources/coleta_local_datasource.dart';
import '../models/coleta_model.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

class ColetaRepositoryImpl implements ColetaRepository {
  final ColetaLocalDatasource _localDatasource;

  ColetaRepositoryImpl(this._localDatasource);

  @override
  Future<List<ColetaEntity>> getAll() => _localDatasource.getAll();

  @override
  Future<List<ColetaEntity>> getPendentes() => _localDatasource.getPendentes();

  @override
  Future<ColetaEntity?> getById(String uuid) => _localDatasource.getById(uuid);

  @override
  Future<void> salvar(ColetaEntity coleta) {
    return _localDatasource.inserir(ColetaModel.fromEntity(coleta));
  }

  @override
  Future<void> atualizarStatus(String uuid, dynamic status, int novaVersao) {
    return _localDatasource.atualizarStatus(
      uuid,
      status as StatusColeta,
      novaVersao,
    );
  }

  @override
  Future<void> deletar(String uuid) => _localDatasource.deletar(uuid);
}
