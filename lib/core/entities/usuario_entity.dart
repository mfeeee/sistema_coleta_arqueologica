class UsuarioEntity {
  final String id;
  final String nome;
  final String? email;
  final String? avatarUrl;
  final DateTime? deletedAt;

  const UsuarioEntity({
    required this.id,
    required this.nome,
    this.email,
    this.avatarUrl,
    this.deletedAt,
  });

  bool get ativo => deletedAt == null;
}
