import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

sealed class AuthResult {
  const AuthResult();
}

final class AuthSuccess extends AuthResult {
  const AuthSuccess({required this.userName, required this.userId});
  final String userName;
  final String userId;
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
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      switch (response.statusCode) {
        case 200:
          final token = body['token'] as String?;
          if (token == null) {
            return const AuthFailure('Resposta inválida do servidor.');
          }
          await secureStorage.saveJwt(token);
          final user = body['user'] as Map<String, dynamic>?;
          return AuthSuccess(
            userName: user?['name'] as String? ?? 'Usuário',
            userId: user?['id'] as String? ?? '',
          );

        case 401:
          return const AuthFailure('E-mail ou senha incorretos.');

        case 403:
          return const AuthFailure(
            'Conta desativada. Contate o administrador.',
          );

        default:
          final msg = body['message'] as String?;
          return AuthFailure(msg ?? 'Erro inesperado (${response.statusCode})');
      }
    } on SocketException {
      return const AuthFailure('Sem conexão com o servidor.');
    } on http.ClientException catch (e) {
      log('Erro HTTP no login', error: e, name: 'AuthService');
      return const AuthFailure('Falha na comunicação com o servidor.');
    } catch (e) {
      log('Erro desconhecido no login', error: e, name: 'AuthService');
      return const AuthFailure('Ocorreu um erro inesperado.');
    }
  }

  Future<bool> refreshToken() async {
    log(
      'Sanctum não suporta refresh. Forçando novo login.',
      name: 'AuthService',
    );
    return false;
  }

  Future<void> logout() async {
    try {
      final token = await secureStorage.getJwt();
      if (token != null) {
        await httpClient.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      log('Falha ao chamar /auth/logout', error: e, name: 'AuthService');
    } finally {
      await secureStorage.clearAll();
    }
  }
}
