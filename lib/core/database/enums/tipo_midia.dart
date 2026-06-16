enum TipoMidia {
  imagem,
  video,
  tese,
  artigo;

  static TipoMidia fromString(String value) => TipoMidia.values.firstWhere(
    (e) => e.name == value,
    orElse: () => TipoMidia.imagem,
  );
}
