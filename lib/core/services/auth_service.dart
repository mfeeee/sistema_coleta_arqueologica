import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import 'secure_storage_service.dart';

const _kTimeoutRequisicao = Duration(seconds: 15);

sealed class AuthResult {
  const AuthResult();
}

sealed class RecuperacaoResult {
  const RecuperacaoResult();
}

final class RecuperacaoSucesso extends RecuperacaoResult {
  const RecuperacaoSucesso();
}

final class RecuperacaoFalha extends RecuperacaoResult {
  const RecuperacaoFalha(this.message);
  final String message;
}

final class AuthSuccess extends AuthResult {
  AuthSuccess({
    required this.userName,
    required this.userId,
    this.email,
    this.classificacao,
  });
  final String userName;
  final String userId;
  final String? email;
  final String? classificacao;
}

final class AuthFailure extends AuthResult {
  const AuthFailure(this.message);
  final String message;
}

class AuthService {
  AuthService({
    required this.secureStorage,
    required this.httpClient,
    required this.baseUrl,
  });

  final SecureStorageService secureStorage;
  final http.Client httpClient;
  final String baseUrl;

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_kTimeoutRequisicao);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      switch (response.statusCode) {
        case 200:
          final token = body['token'] as String?;
          if (token == null) {
            return const AuthFailure(TratadorDeErros.respostaInvalida);
          }
          await secureStorage.saveJwt(token);
          final user = body['user'] as Map<String, dynamic>?;
          return AuthSuccess(
            userName: user?['name'] as String? ?? 'Usuário',
            userId: user?['id']?.toString() ?? '',
            email: user?['email'] as String?,
            classificacao: user?['classificacao'] as String?,
          );

        case 401:
          return const AuthFailure(TratadorDeErros.credenciaisInvalidas);

        case 403:
          return const AuthFailure(TratadorDeErros.contaDesativada);

        default:
          final msg = body['message'] as String?;
          return AuthFailure(msg ?? TratadorDeErros.erroInesperado);
      }
    } on SocketException {
      return const AuthFailure(TratadorDeErros.semConexao);
    } on TimeoutException {
      return const AuthFailure(TratadorDeErros.timeout);
    } on http.ClientException catch (e) {
      log('Erro HTTP no login', error: e, name: 'AuthService');
      return const AuthFailure(TratadorDeErros.erroComunicacao);
    } catch (e) {
      log('Erro desconhecido no login', error: e, name: 'AuthService');
      return const AuthFailure(TratadorDeErros.erroInesperado);
    }
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String classificacao,
  }) async {
    try {
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation': password,
              'classificacao': classificacao,
            }),
          )
          .timeout(_kTimeoutRequisicao);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      switch (response.statusCode) {
        case 201:
          final token = body['token'] as String?;
          if (token == null) {
            return const AuthFailure(TratadorDeErros.respostaInvalida);
          }
          await secureStorage.saveJwt(token);
          final userBody = body['user'] as Map<String, dynamic>?;
          return AuthSuccess(
            userName: userBody?['name'] as String? ?? name,
            userId: userBody?['id']?.toString() ?? '',
            email: email,
            classificacao: classificacao,
          );

        case 422:
          final errors = body['errors'] as Map<String, dynamic>?;
          final first = errors?.values.first;
          final msg = (first is List && first.isNotEmpty)
              ? first.first as String
              : TratadorDeErros.erroInesperado;
          return AuthFailure(msg);

        default:
          final msg = body['message'] as String?;
          return AuthFailure(msg ?? TratadorDeErros.erroInesperado);
      }
    } on SocketException {
      return const AuthFailure(TratadorDeErros.semConexao);
    } on TimeoutException {
      return const AuthFailure(TratadorDeErros.timeout);
    } on http.ClientException catch (e) {
      log('Erro HTTP no registro', error: e, name: 'AuthService');
      return const AuthFailure(TratadorDeErros.erroComunicacao);
    } catch (e) {
      log('Erro desconhecido no registro', error: e, name: 'AuthService');
      return const AuthFailure(TratadorDeErros.erroInesperado);
    }
  }

  Future<RecuperacaoResult> solicitarRecuperacaoSenha(String email) async {
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
          .timeout(_kTimeoutRequisicao);

      // 200 e 404 retornam sucesso por segurança (não revelar se e-mail existe)
      if (response.statusCode == 200 || response.statusCode == 404) {
        return const RecuperacaoSucesso();
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final msg = body['message'] as String?;
      return RecuperacaoFalha(msg ?? TratadorDeErros.erroInesperado);
    } on SocketException {
      return const RecuperacaoFalha(TratadorDeErros.semConexao);
    } on TimeoutException {
      return const RecuperacaoFalha(TratadorDeErros.timeout);
    } on http.ClientException catch (e) {
      log('Erro HTTP na recuperação de senha', error: e, name: 'AuthService');
      return const RecuperacaoFalha(TratadorDeErros.erroComunicacao);
    } catch (e) {
      log('Erro desconhecido na recuperação', error: e, name: 'AuthService');
      return const RecuperacaoFalha(TratadorDeErros.erroInesperado);
    }
  }

  Future<bool> renovarToken() async {
    try {
      final token = await secureStorage.getJwt();
      if (token == null) return false;

      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/auth/refresh'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_kTimeoutRequisicao);

      if (response.statusCode != 200) {
        log(
          'Falha ao renovar token: ${response.statusCode}',
          name: 'AuthService',
        );
        return false;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final novoToken = body['token'] as String?;
      if (novoToken == null) return false;

      await secureStorage.saveJwt(novoToken);
      return true;
    } catch (e) {
      log('Erro ao renovar token', error: e, name: 'AuthService');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final token = await secureStorage.getJwt();
      if (token != null) {
        await httpClient
            .post(
              Uri.parse('$baseUrl/auth/logout'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(_kTimeoutRequisicao);
      }
    } catch (e) {
      log('Falha ao chamar /auth/logout', error: e, name: 'AuthService');
    } finally {
      await secureStorage.clearAll();
    }
  }
}
