enum TipoPino {
  coleta,
  bemPublicado,
  padrao;

  String get rotulo => switch (this) {
    TipoPino.coleta => 'Minha Coleta',
    TipoPino.bemPublicado => 'Bem Publicado',
    TipoPino.padrao => 'Outros',
  };
}
