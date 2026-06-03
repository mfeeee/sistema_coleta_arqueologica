import '../entities/coleta_entity.dart';

typedef ColetaPage = ({List<ColetaEntity> items, int total, bool temProxima});

abstract interface class ColetaRemotaRepository {
  Future<ColetaPage> fetchMinhas({required int page});
}
