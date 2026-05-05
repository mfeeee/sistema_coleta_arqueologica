import '../entities/coleta_entity.dart';

abstract class ColetaRepository {
  Future<List<ColetaEntity>> getAll();
  Future<List<ColetaEntity>> getPendentes();
  Future<ColetaEntity?> getById(String uuid);
  Future<void> salvar(ColetaEntity coleta);
  Future<void> atualizarStatus(String uuid, dynamic status, int novaVersao);
  Future<void> deletar(String uuid);
}
