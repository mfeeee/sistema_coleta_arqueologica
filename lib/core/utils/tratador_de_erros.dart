import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

abstract final class TratadorDeErros {
  static const credenciaisInvalidas =
      'E-mail ou senha incorretos. Verifique e tente novamente.';
  static const semConexao = 'Sem conexão com a internet. Verifique sua rede.';
  static const timeout =
      'O servidor demorou para responder. Tente novamente em instantes.';
  static const respostaInvalida = 'Resposta inválida do servidor.';
  static const erroComunicacao = 'Falha na comunicação com o servidor.';
  static const erroInesperado = 'Ocorreu um erro inesperado. Tente novamente.';
  static const erroLocalizacao =
      'Não foi possível obter a localização. Tente novamente.';
  static const contaDesativada = 'Conta desativada. Entre em contato.';
  static const sessaoExpirada = 'Sessão expirada. Faça login novamente.';

  static String deExcecao(Object erro) {
    if (erro is DioException) {
      if (erro.type == DioExceptionType.connectionTimeout ||
          erro.type == DioExceptionType.sendTimeout ||
          erro.type == DioExceptionType.receiveTimeout) {
        return timeout;
      }
      if (erro.error is SocketException) return semConexao;
      return erroComunicacao;
    }
    if (erro is SocketException) return semConexao;
    if (erro is TimeoutException) return timeout;
    return erroInesperado;
  }
}
