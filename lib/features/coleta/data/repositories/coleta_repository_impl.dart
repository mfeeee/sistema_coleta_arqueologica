import '../../domain/entities/coleta_entity.dart';
import '../../domain/repositories/coleta_repository.dart';
import '../datasources/coleta_local_datasource.dart';
import '../models/coleta_model.dart';
import 'dart:developer';

class ColetaRepositoryImpl implements ColetaRepository {
  final ColetaLocalDatasource _localDatasource;

  ColetaRepositoryImpl(this._localDatasource);

  @override
  Future<List<ColetaEntity>> getBemMaterialsCacheOffline() async {
    try {
      return await _localDatasource.getAllBensMateriaisCache();
    } catch (e) {
      log('Erro ao buscar sítios no cache', error: e, name: 'ColetaRepository');
      throw Exception('Erro ao procurar sítios no cache: $e');
    }
  }

  @override
  Future<void> salvarNovaColeta(ColetaEntity entity) async {
    try {
      final model = ColetaModel.fromEntity(entity);
      await _localDatasource.insertBemMaterial(model);
    } catch (e) {
      log('Erro ao salvar coleta', error: e, name: 'ColetaRepository');
      throw Exception('Erro ao salvar coleta: $e');
    }
  }
}
