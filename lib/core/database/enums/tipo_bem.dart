enum TipoBem {
  acervoOuColecao('Acervo ou Coleção'),
  bemOuConjunto('Bem ou conjunto de bens arqueológicos móveis'),
  colecao('Coleção'),
  sitio('Sítio');

  const TipoBem(this.label);
  final String label;

  static TipoBem fromString(String value) =>
      TipoBem.values.firstWhere((e) => e.name == value);
}
