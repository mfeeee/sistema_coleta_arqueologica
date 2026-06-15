import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/criar_coleta_use_case.dart';

CriarColetaInput _inputBase() => const CriarColetaInput(
  nome: 'Sítio Pedra do Encantado',
  nomesPopulares: ['Pedra Mágica'],
  artefatoTipos: [],
  midias: [],
  usuarioId: 'arq-001',
  natureza: NaturezaBem.bemArqueologico,
  tipo: TipoBem.sitio,
);

void main() {
  const useCase = CriarColetaUseCase();

  group('CriarColetaUseCase.call — criação de coleta finalizada', () {
    test('cria coleta com status pendente', () {
      final result = useCase.call(_inputBase());
      check(result.coleta.syncStatus).equals(StatusColeta.pendente);
    });

    test('nome é trimado corretamente', () {
      const input = CriarColetaInput(
        nome: '  Sítio com espaços  ',
        nomesPopulares: [],
        artefatoTipos: [],
        midias: [],
        usuarioId: 'u1',
      );
      final result = useCase.call(input);
      check(result.coleta.nomeBem).equals('Sítio com espaços');
    });

    test('coleta e bemMaterial têm IDs distintos mas coletaId vinculado', () {
      final result = useCase.call(_inputBase());
      check(result.coleta.id).isNotEmpty();
      check(result.bemMaterial.id).isNotEmpty();
      check(result.coleta.id).not((it) => it.equals(result.bemMaterial.id));
      check(result.bemMaterial.coletaId).equals(result.coleta.id);
    });

    test('versão inicial é 1', () {
      final result = useCase.call(_inputBase());
      check(result.coleta.versao).equals(1);
    });
  });

  group('CriarColetaUseCase.criarRascunho — rascunho parcial', () {
    test('status do rascunho é rascunho', () {
      final result = useCase.criarRascunho(_inputBase());
      check(result.syncStatus).equals(StatusColeta.rascunho);
    });

    test('nome vazio usa fallback "Rascunho"', () {
      const input = CriarColetaInput(
        nome: '',
        nomesPopulares: [],
        artefatoTipos: [],
        midias: [],
        usuarioId: 'u1',
      );
      final result = useCase.criarRascunho(input);
      check(result.nomeBem).equals('Rascunho');
    });

    test('ID fornecido é preservado no rascunho', () {
      const input = CriarColetaInput(
        id: 'id-fixo-123',
        nome: 'Qualquer',
        nomesPopulares: [],
        artefatoTipos: [],
        midias: [],
        usuarioId: 'u1',
      );
      final result = useCase.criarRascunho(input);
      check(result.id).equals('id-fixo-123');
    });
  });
}
