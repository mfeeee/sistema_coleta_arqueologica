class LocalizacaoEntity {
  final String id;
  final String? cep;
  final String? logradouro;
  final String? municipio;
  final String? uf;
  final double? lat;
  final double? lng;

  const LocalizacaoEntity({
    required this.id,
    this.cep,
    this.logradouro,
    this.municipio,
    this.uf,
    this.lat,
    this.lng,
  });
}
