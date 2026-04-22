import '../../domain/entities/sitio_cache_entity.dart';
import '../../domain/repositories/coleta_repository.dart';
import '../datasources/sitio_local_datasource.dart';
import '../models/sitio_cache_model.dart';

class ColetaRepositoryImpl implements ColetaRepository {
  final SitioLocalDatasource localDatasource;

  ColetaRepositoryImpl(this.localDatasource);

  @override
  Future<List<SitioCacheEntity>> getSitiosCacheOffline() async {
    try {
      final List<SitioCacheModel> modelos = await localDatasource
          .getAllSitiosCache();

      return modelos;
    } catch (e) {
      throw Exception('Erro ao procurar sítios no cache: $e');
    }
  }

  @override
  Future<void> salvarNovaColeta(SitioCacheEntity novoSitio) async {
    throw UnimplementedError('Ainda vou implementar');
  }
}
