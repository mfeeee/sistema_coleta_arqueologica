import '../entities/sitio_cache_entity.dart';

abstract class ColetaRepository {
  Future<List<SitioCacheEntity>> getSitiosCacheOffline();

  Future<void> salvarNovaColeta(SitioCacheEntity novoSitio);
}
