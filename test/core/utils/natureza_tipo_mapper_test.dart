import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/natureza_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_bem.dart';
import 'package:sistema_coleta_arqueologica/core/utils/natureza_tipo_mapper.dart';

void main() {
  group('tiposPermitidosPorNatureza', () {
    test('deve retornar lista vazia quando natureza for null', () {
      final resultado = tiposPermitidosPorNatureza(null);
      expect(resultado, isEmpty);
    });

    test('deve retornar [colecao, sitio] para bem paleontológico', () {
      final resultado = tiposPermitidosPorNatureza(
        NaturezaBem.bemPaleontologico,
      );

      expect(resultado, equals([TipoBem.colecao, TipoBem.sitio]));
    });

    test('deve retornar todos os 4 tipos permitidos para bem arqueológico', () {
      final resultado = tiposPermitidosPorNatureza(NaturezaBem.bemArqueologico);

      expect(
        resultado,
        equals([
          TipoBem.acervoOuColecao,
          TipoBem.colecao,
          TipoBem.bemOuConjunto,
          TipoBem.sitio,
        ]),
      );
    });
  });
}
