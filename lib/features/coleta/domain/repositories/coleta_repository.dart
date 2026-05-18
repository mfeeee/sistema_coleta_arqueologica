import '../entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';

abstract class ColetaRepository {
  Future<List<ColetaEntity>> getAll();
  Future<List<ColetaEntity>> getPendentes();
  Future<ColetaEntity?> getById(String uuid);
  Future<int> contarTodas();
  Future<int> contarPorStatus(StatusColeta status);
  Future<List<ColetaEntity>> getRecentes(int limite);
  Future<void> salvar(ColetaEntity coleta);
  Future<void> atualizarStatus(String uuid, dynamic status, int novaVersao);
  Future<void> deletar(String uuid);
}
