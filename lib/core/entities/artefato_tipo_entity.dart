class ArtefatoTipoEntity {
  final String id;
  final String nome;
  final String? descricaoNova;
  final bool novoTipo;

  const ArtefatoTipoEntity({
    required this.id,
    required this.nome,
    this.descricaoNova,
    this.novoTipo = false,
  });
}
