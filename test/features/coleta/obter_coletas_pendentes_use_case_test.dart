import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/obter_coletas_pendentes_use_case.dart';

// ---------------------------------------------------------------------------
// Fake
// ---------------------------------------------------------------------------

class _FakeColetaRepository implements ColetaRepository {
  List<ColetaEntity> retornoPendentes = [];

  @override
  Future<List<ColetaEntity>> getPendentes() async => retornoPendentes;

  @override
  Future<List<ColetaEntity>> getAll() async => [];

  @override
  Future<ColetaEntity?> getById(String uuid) async => null;

  @override
  Future<int> contarTodas() async => 0;

  @override
  Future<int> contarPorStatus(StatusColeta status) async => 0;

  @override
  Future<List<ColetaEntity>> getRecentes(int limite) async => [];

  @override
  Future<void> salvar(ColetaEntity coleta) async {}

  @override
  Future<void> atualizarStatus(
    String uuid,
    dynamic status,
    int novaVersao,
  ) async {}

  @override
  Future<void> deletar(String uuid) async {}
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ColetaEntity _coletaPendente(String id) => ColetaEntity(
  id: id,
  usuarioId: 'u1',
  dataColeta: DateTime(2024),
  syncStatus: StatusColeta.pendente,
  nomeBem: 'Sítio $id',
  latitude: 0,
  longitude: 0,
  artefatos: const <ArtefatoBem>[],
  versao: 1,
  updatedAt: DateTime(2024),
  dadosColetados: const {},
);

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('ObterColetasPendentesUseCase', () {
    test('retorna lista vazia quando não há pendentes', () async {
      final repo = _FakeColetaRepository();
      final useCase = ObterColetasPendentesUseCase(repo);

      final resultado = await useCase.call();

      check(resultado).isEmpty();
    });

    test('retorna apenas coletas com StatusColeta.pendente', () async {
      final repo = _FakeColetaRepository()
        ..retornoPendentes = [_coletaPendente('a'), _coletaPendente('b')];
      final useCase = ObterColetasPendentesUseCase(repo);

      final resultado = await useCase.call();

      check(resultado).length.equals(2);
      check(
        resultado.every((c) => c.syncStatus == StatusColeta.pendente),
      ).isTrue();
    });

    test('propaga exceção do repositório sem suprimir', () async {
      final repoErro = _ThrowingColetaRepository();
      final useCaseErro = ObterColetasPendentesUseCase(repoErro);

      await check(useCaseErro.call()).throws<Exception>();
    });
  });
}

class _ThrowingColetaRepository implements ColetaRepository {
  @override
  Future<List<ColetaEntity>> getPendentes() =>
      Future.error(Exception('erro simulado'));

  @override
  Future<List<ColetaEntity>> getAll() async => [];

  @override
  Future<ColetaEntity?> getById(String uuid) async => null;

  @override
  Future<int> contarTodas() async => 0;

  @override
  Future<int> contarPorStatus(StatusColeta status) async => 0;

  @override
  Future<List<ColetaEntity>> getRecentes(int limite) async => [];

  @override
  Future<void> salvar(ColetaEntity coleta) async {}

  @override
  Future<void> atualizarStatus(
    String uuid,
    dynamic status,
    int novaVersao,
  ) async {}

  @override
  Future<void> deletar(String uuid) async {}
}
