import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';

class FakeColetaRepository implements ColetaRepository {
  FakeColetaRepository([List<ColetaEntity>? coletas])
    : _coletas = coletas ?? [];

  final List<ColetaEntity> _coletas;

  @override
  Future<List<ColetaEntity>> getAll() async => List.unmodifiable(_coletas);

  @override
  Future<List<ColetaEntity>> getPendentes() async =>
      _coletas.where((c) => c.syncStatus == StatusColeta.pendente).toList();

  @override
  Future<ColetaEntity?> getById(String uuid) async =>
      _coletas.where((c) => c.id == uuid).firstOrNull;

  @override
  Future<int> contarTodas() async => _coletas.length;

  @override
  Future<int> contarPorStatus(dynamic status) async =>
      _coletas.where((c) => c.syncStatus == status).length;

  @override
  Future<List<ColetaEntity>> getRecentes(int limite) async =>
      _coletas.take(limite).toList();

  @override
  Future<void> salvar(ColetaEntity coleta) async => _coletas.add(coleta);

  @override
  Future<void> atualizarStatus(
    String uuid,
    dynamic status,
    int novaVersao,
  ) async {}

  @override
  Future<void> deletar(String uuid) async =>
      _coletas.removeWhere((c) => c.id == uuid);
}
