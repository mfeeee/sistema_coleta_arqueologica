import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';

const _kTimeout = Duration(seconds: 15);

sealed class RequestResetResult {
  const RequestResetResult();
}

final class RequestResetSucesso extends RequestResetResult {
  const RequestResetSucesso();
}

final class RequestResetFalha extends RequestResetResult {
  const RequestResetFalha(this.mensagem);
  final String mensagem;
}

sealed class ConfirmResetResult {
  const ConfirmResetResult();
}

final class ConfirmResetSucesso extends ConfirmResetResult {
  const ConfirmResetSucesso();
}

final class ConfirmResetFalha extends ConfirmResetResult {
  const ConfirmResetFalha(this.mensagem);
  final String mensagem;
}

class PasswordResetRepository {
  PasswordResetRepository({required this.httpClient, required this.baseUrl});

  final http.Client httpClient;
  final String baseUrl;

  Future<RequestResetResult> requestReset(String email) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/auth/password-reset'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(_kTimeout);

      if (response.statusCode == 200 || response.statusCode == 404) {
        return const RequestResetSucesso();
      }

      final body = _parsearBody(response.body);
      return RequestResetFalha(_extrairMensagem(body));
    } on SocketException {
      return const RequestResetFalha(TratadorDeErros.semConexao);
    } on TimeoutException {
      return const RequestResetFalha(TratadorDeErros.timeout);
    } on http.ClientException catch (e) {
      log(
        'Erro HTTP em requestReset',
        error: e,
        name: 'PasswordResetRepository',
      );
      return const RequestResetFalha(TratadorDeErros.erroComunicacao);
    } catch (e) {
      log(
        'Erro desconhecido em requestReset',
        error: e,
        name: 'PasswordResetRepository',
      );
      return const RequestResetFalha(TratadorDeErros.erroInesperado);
    }
  }

  Future<ConfirmResetResult> confirmReset(
    String token,
    String novaSenha,
  ) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/auth/password-reset/confirm'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'token': token,
              'password': novaSenha,
              'password_confirmation': novaSenha,
            }),
          )
          .timeout(_kTimeout);

      if (response.statusCode == 200) return const ConfirmResetSucesso();

      final body = _parsearBody(response.body);
      return ConfirmResetFalha(_extrairMensagem(body));
    } on SocketException {
      return const ConfirmResetFalha(TratadorDeErros.semConexao);
    } on TimeoutException {
      return const ConfirmResetFalha(TratadorDeErros.timeout);
    } on http.ClientException catch (e) {
      log(
        'Erro HTTP em confirmReset',
        error: e,
        name: 'PasswordResetRepository',
      );
      return const ConfirmResetFalha(TratadorDeErros.erroComunicacao);
    } catch (e) {
      log(
        'Erro desconhecido em confirmReset',
        error: e,
        name: 'PasswordResetRepository',
      );
      return const ConfirmResetFalha(TratadorDeErros.erroInesperado);
    }
  }

  Map<String, dynamic> _parsearBody(String bodyStr) {
    try {
      return jsonDecode(bodyStr) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  String _extrairMensagem(Map<String, dynamic> body) {
    final errors = body['errors'] as Map<String, dynamic>?;
    if (errors != null) {
      final primeiro = errors.values.firstOrNull;
      if (primeiro is List && primeiro.isNotEmpty) {
        return primeiro.first as String? ?? TratadorDeErros.erroInesperado;
      }
    }
    return body['message'] as String? ?? TratadorDeErros.erroInesperado;
  }
}
