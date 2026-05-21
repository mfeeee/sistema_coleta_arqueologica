sealed class ArqueoException implements Exception {
  const ArqueoException(this.mensagem);
  final String mensagem;

  @override
  String toString() => '$runtimeType: $mensagem';
}

final class ErroDeRede extends ArqueoException {
  const ErroDeRede([
    super.mensagem = 'Sem conexão com a internet. Verifique sua rede.',
  ]);
}

final class ErroDeAutorizacao extends ArqueoException {
  const ErroDeAutorizacao([
    super.mensagem = 'Sessão expirada. Faça login novamente.',
  ]);
}

final class ErroDeServidor extends ArqueoException {
  const ErroDeServidor([
    super.mensagem = 'Erro interno do servidor. Tente novamente.',
  ]);
}

final class ErroDeValidacao extends ArqueoException {
  const ErroDeValidacao([
    super.mensagem = 'Dados inválidos. Verifique as informações.',
  ]);
}

final class ErroDeBancoDeDados extends ArqueoException {
  const ErroDeBancoDeDados([super.mensagem = 'Erro no banco de dados local.']);
}
