import '../entities/bem_material_cache_entity.dart';

abstract class ColetaRepository {
  Future<List<BemMaterialCacheEntity>> getBemMaterialsCacheOffline();

  Future<void> salvarNovaColeta(BemMaterialCacheEntity novoBemMaterial);
}
