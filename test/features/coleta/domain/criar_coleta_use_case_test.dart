import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/criar_coleta_use_case.dart';

CriarColetaInput _input({String nome = 'Sítio Teste', String? id}) =>
    CriarColetaInput(
      id: id,
      nome: nome,
      nomesPopulares: const ['Nome popular'],
      artefatoTipos: const [],
      midias: const [],
      usuarioId: 'arq-001',
      natureza: NaturezaBem.bemArqueologico,
      tipo: TipoBem.sitio,
    );

void main() {
  const useCase = CriarColetaUseCase();

  group('CriarColetaUseCase.call', () {
    test('status da coleta criada é pendente', () {
      final result = useCase.call(_input());
      check(result.coleta.syncStatus).equals(StatusColeta.pendente);
    });

    test('nome é trimado', () {
      final result = useCase.call(_input(nome: '  Sítio X  '));
      check(result.coleta.nomeBem).equals('Sítio X');
    });

    test('IDs da coleta e bemMaterial são distintos', () {
      final result = useCase.call(_input());
      check(result.coleta.id).not((it) => it.equals(result.bemMaterial.id));
    });

    test('bemMaterial.coletaId aponta para coleta.id', () {
      final result = useCase.call(_input());
      check(result.bemMaterial.coletaId).equals(result.coleta.id);
    });

    test('versão inicial é 1', () {
      final result = useCase.call(_input());
      check(result.coleta.versao).equals(1);
    });

    test('ID fornecido é preservado', () {
      final result = useCase.call(_input(id: 'id-fixo'));
      check(result.coleta.id).equals('id-fixo');
    });
  });

  group('CriarColetaUseCase.criarRascunho', () {
    test('status do rascunho é rascunho', () {
      final result = useCase.criarRascunho(_input());
      check(result.syncStatus).equals(StatusColeta.rascunho);
    });

    test('nome vazio usa fallback Rascunho', () {
      final result = useCase.criarRascunho(_input(nome: ''));
      check(result.nomeBem).equals('Rascunho');
    });

    test('nome com espaços usa fallback Rascunho', () {
      final result = useCase.criarRascunho(_input(nome: '   '));
      check(result.nomeBem).equals('Rascunho');
    });
  });
}
