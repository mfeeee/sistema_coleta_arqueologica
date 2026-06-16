import '../database/enums/natureza_bem.dart';
import '../database/enums/tipo_bem.dart';

List<TipoBem> tiposPermitidosPorNatureza(NaturezaBem? natureza) {
  if (natureza == null) return const [];

  switch (natureza) {
    case NaturezaBem.bemPaleontologico:
      return const [TipoBem.colecao, TipoBem.sitio];
    case NaturezaBem.bemArqueologico:
      return const [
        TipoBem.acervoOuColecao,
        TipoBem.colecao,
        TipoBem.bemOuConjunto,
        TipoBem.sitio,
      ];
  }
}
