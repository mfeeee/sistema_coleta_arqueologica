enum TipoMidia {
  foto,
  video,
  tese,
  artigo;

  static TipoMidia fromString(String value) => TipoMidia.values.firstWhere(
    (e) => e.name == value,
    orElse: () => TipoMidia.foto,
  );
}
