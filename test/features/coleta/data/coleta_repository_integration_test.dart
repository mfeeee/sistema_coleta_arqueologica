// test/features/coleta/data/coleta_repository_integration_test.dart
import 'package:checks/checks.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/app_database.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_local_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/repositories/coleta_repository_impl.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/criar_coleta_use_case.dart';

void main() {
  late AppDatabase db;
  late ColetaRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final datasource = ColetaLocalDatasourceImpl(db);
    repository = ColetaRepositoryImpl(datasource);
  });

  tearDown(() => db.close());

  const useCase = CriarColetaUseCase();

  CriarColetaInput input(String nome) => CriarColetaInput(
    nome: nome,
    nomesPopulares: const ['Nome popular'],
    artefatoTipos: const [],
    midias: const [],
    usuarioId: 'arq-001',
    natureza: NaturezaBem.bemArqueologico,
    tipo: TipoBem.sitio,
  );

  group('ColetaRepository — integração completa', () {
    test('salvar e listar coleta', () async {
      final result = useCase.call(input('Sítio da Serra'));
      await repository.salvar(result.coleta);

      final coletas = await repository.getAll();
      check(coletas.map((c) => c.nomeBem)).contains('Sítio da Serra');
    });

    test('getPendentes retorna apenas pendentes', () async {
      final r1 = useCase.call(input('Sítio A'));
      final r2 = useCase.call(input('Sítio B'));
      await repository.salvar(r1.coleta);
      await repository.salvar(r2.coleta);

      final pendentes = await repository.getPendentes();
      check(pendentes).has((l) => l.length, 'length').equals(2);
      check(
        pendentes.every((c) => c.syncStatus == StatusColeta.pendente),
      ).isTrue();
    });

    test('salvar rascunho e listar', () async {
      final rascunho = useCase.criarRascunho(input('Rascunho Inicial'));
      await repository.salvar(rascunho);

      final coletas = await repository.getAll();
      check(coletas.map((c) => c.nomeBem)).contains('Rascunho Inicial');
      check(
        coletas.firstWhere((c) => c.nomeBem == 'Rascunho Inicial').syncStatus,
      ).equals(StatusColeta.rascunho);
    });
  });
}
