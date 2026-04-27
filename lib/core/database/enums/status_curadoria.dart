enum StatusCuradoria {
  pendente,
  aprovado,
  rejeitado;

  static StatusCuradoria fromString(String value) =>
      StatusCuradoria.values.firstWhere(
        (e) => e.name == value,
        orElse: () => StatusCuradoria.pendente,
      );
}

enum AcaoResultanteCuradoria {
  criarSitio,
  atualizarSitio,
  rejeitar;

  static AcaoResultanteCuradoria fromString(String value) =>
      AcaoResultanteCuradoria.values.firstWhere(
        (e) => e.name == value,
        orElse: () => AcaoResultanteCuradoria.rejeitar,
      );
}
