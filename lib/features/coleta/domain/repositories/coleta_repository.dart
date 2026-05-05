import '../entities/coleta_entity.dart';

abstract class ColetaRepository {
  Future<List<ColetaEntity>> getBemMaterialsCacheOffline();

  Future<void> salvarNovaColeta(ColetaEntity novoBemMaterial);
}
