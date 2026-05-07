enum ArtefatoBem {
  faianca('Faiança'),
  malacologico('Malacológico'),
  semente('Semente'),
  ossosFaunisticos('Ossos faunísticos'),
  ceramica('Cerâmica'),
  plastico('Plástico'),
  gres('Grés'),
  carvao('Carvão'),
  faiancaFina('Faiança fina'),
  madeira('Madeira'),
  porcelana('Porcelana'),
  textil('Têxtil'),
  litico('Lítico'),
  fibraVegetal('Fibra Vegetal'),
  vitreo('Vítreo'),
  borracha('Borracha'),
  sedimento('Sedimento'),
  ceramicaVidrada('Cerâmica vidrada'),
  metalico('Metálico'),
  ossosHumanos('Ossos humanos'),
  outros('Outros');

  const ArtefatoBem(this.label);
  final String label;

  static ArtefatoBem? tryFromString(String value) {
    final key = value.split(':').first;
    try {
      return ArtefatoBem.values.firstWhere((e) => e.name == key);
    } catch (_) {
      return null;
    }
  }
}
