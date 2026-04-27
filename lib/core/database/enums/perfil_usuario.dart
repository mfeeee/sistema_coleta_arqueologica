enum PerfilUsuario {
  coletor,
  curador,
  admin;

  static PerfilUsuario fromString(String value) => PerfilUsuario.values
      .firstWhere((e) => e.name == value, orElse: () => PerfilUsuario.coletor);
}

enum ClassificacaoUsuario {
  estudante,
  professor,
  arqueologo;

  static ClassificacaoUsuario fromString(String value) =>
      ClassificacaoUsuario.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ClassificacaoUsuario.estudante,
      );
}
