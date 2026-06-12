import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/usecases/criar_coleta_use_case.dart';

CriarColetaInput _inputValido({String nome = 'Sítio das Pedras'}) =>
    CriarColetaInput(
      nome: nome,
      nomesPopulares: const ['Pedreira'],
      natureza: NaturezaBem.bemArqueologico,
      tipo: TipoBem.sitio,
      artefatos: const [ArtefatoBem.ceramica],
      meiosAcesso: 'A pé, 30 min',
      fotoPaths: const [],
      lat: -2.9078,
      lng: -41.7722,
      usuarioId: 'usuario-42',
    );

void main() {
  const useCase = CriarColetaUseCase();

  group('CriarColetaUseCase.call — coleta final', () {
    test('cria ColetaEntity com syncStatus pendente', () {
      // Arrange
      final input = _inputValido();

      // Act
      final result = useCase.call(input);

      // Assert
      check(result.coleta.syncStatus).equals(StatusColeta.pendente);
    });

    test('coleta recebe todos os campos do input corretamente', () {
      final input = _inputValido();

      final result = useCase.call(input);
      final coleta = result.coleta;

      check(coleta.nomeBem).equals('Sítio das Pedras');
      check(coleta.usuarioId).equals('usuario-42');
      check(coleta.localizacao?.lat).isNotNull();
      check(coleta.localizacao!.lat!).isCloseTo(-2.9078, 0.0001);
      check(coleta.localizacao!.lng!).isCloseTo(-41.7722, 0.0001);
      check(coleta.versao).equals(1);
      check(coleta.id).isNotEmpty();
    });

    test('BemMaterialEntity recebe o mesmo coletaId da coleta criada', () {
      final input = _inputValido();

      final result = useCase.call(input);

      check(result.bemMaterial.coletaId).equals(result.coleta.id);
    });

    test('id da coleta e id do bemMaterial são distintos', () {
      final result = useCase.call(_inputValido());

      check(result.coleta.id).isNotEmpty();
      check(result.bemMaterial.id).isNotEmpty();
      check(result.coleta.id == result.bemMaterial.id).isFalse();
    });

    test('nome com espaços extras é normalizado com trim', () {
      final input = _inputValido(nome: '  Sítio X  ');

      final result = useCase.call(input);

      check(result.coleta.nomeBem).equals('Sítio X');
      check(result.bemMaterial.nomeBem).equals('Sítio X');
    });
  });

  group('CriarColetaUseCase.criarRascunho', () {
    test('cria ColetaEntity com syncStatus rascunho', () {
      // Arrange
      final input = _inputValido();

      // Act
      final rascunho = useCase.criarRascunho(input);

      // Assert
      check(rascunho.syncStatus).equals(StatusColeta.rascunho);
    });

    test('usa "Rascunho" como nomeBem quando nome está vazio', () {
      const input = CriarColetaInput(
        nome: '',
        nomesPopulares: [],
        artefatos: [],
        fotoPaths: [],
        lat: 0,
        lng: 0,
        usuarioId: 'u1',
      );

      final rascunho = useCase.criarRascunho(input);

      check(rascunho.nomeBem).equals('Rascunho');
    });

    test('preserva o nome quando fornecido', () {
      final input = _inputValido(nome: 'Sítio Real');

      final rascunho = useCase.criarRascunho(input);

      check(rascunho.nomeBem).equals('Sítio Real');
    });
  });
}
