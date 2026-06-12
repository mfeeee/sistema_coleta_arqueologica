class UsuarioEntity {
  final String id;
  final String nome;
  final String? email;
  final String? avatarUrl;

  const UsuarioEntity({
    required this.id,
    required this.nome,
    this.email,
    this.avatarUrl,
  });
}
