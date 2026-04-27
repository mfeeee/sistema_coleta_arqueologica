import '../../domain/entities/bem_material_cache_entity.dart';
import '../../domain/repositories/coleta_repository.dart';
import '../datasources/bem_material_local_datasource.dart';
import '../models/bem_material_cache_model.dart';
import 'dart:developer';
import '../../../../core/database/enums/status_coleta.dart';

class ColetaRepositoryImpl implements ColetaRepository {
  final BemMaterialLocalDatasource _localDatasource;

  ColetaRepositoryImpl(this._localDatasource);

  @override
  Future<List<BemMaterialCacheEntity>> getBemMaterialsCacheOffline() async {
    try {
      return await _localDatasource.getAllBensMateriaisCache();
    } catch (e) {
      log('Erro ao buscar sítios no cache', error: e, name: 'ColetaRepository');
      throw Exception('Erro ao procurar sítios no cache: $e');
    }
  }

  @override
  Future<void> salvarNovaColeta(BemMaterialCacheEntity novoBemMaterial) async {
    try {
      final model = BemMaterialCacheModel(
        id: novoBemMaterial.id,
        nome: novoBemMaterial.nome,
        latitude: novoBemMaterial.latitude,
        longitude: novoBemMaterial.longitude,
        usuarioId: '',
        syncStatus: StatusColeta.pendente,
        versao: 1,
        updatedAt: DateTime.now(),
      );
      await _localDatasource.insertBemMaterial(model);
    } catch (e) {
      log('Erro ao salvar coleta', error: e, name: 'ColetaRepository');
      throw Exception('Erro ao salvar coleta: $e');
    }
  }
}
