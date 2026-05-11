import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

abstract final class TratadorDeErros {
  static const credenciaisInvalidas =
      'E-mail ou senha incorretos. Verifique e tente novamente.';
  static const semConexao = 'Sem conexão com a internet. Verifique sua rede.';
  static const timeout =
      'O servidor demorou para responder. Tente novamente em instantes.';
  static const respostaInvalida = 'Resposta inválida do servidor.';
  static const erroComunicacao = 'Falha na comunicação com o servidor.';
  static const erroInesperado = 'Ocorreu um erro inesperado. Tente novamente.';
  static const contaDesativada = 'Conta desativada. Contate o administrador.';

  static String deExcecao(Object erro) {
    if (erro is SocketException) return semConexao;
    if (erro is TimeoutException) return timeout;
    if (erro is http.ClientException) return erroComunicacao;
    return erroInesperado;
  }
}
