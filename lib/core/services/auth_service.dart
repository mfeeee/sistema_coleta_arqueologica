import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

sealed class AuthResult {
  const AuthResult();
}

final class AuthSuccess extends AuthResult {
  const AuthSuccess();
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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        await secureStorage.saveJwt(body['access_token'] as String);
        await secureStorage.saveRefreshToken(body['refresh_token'] as String);
        return const AuthSuccess();
      }

      if (response.statusCode == 401) {
        return const AuthFailure('E-mail ou senha incorretos.');
      }

      return AuthFailure('Erro inesperado (${response.statusCode})');
    } on SocketException {
      return const AuthFailure('Sem conexão com a internet.');
    } on http.ClientException catch (e) {
      log('Erro HTTP no login', error: e, name: 'AuthService');
      return const AuthFailure('Falha na comunicação com o servidor.');
    } catch (e) {
      log('Erro desconhecido no login', error: e, name: 'AuthService');
      return const AuthFailure('Ocorreu um erro inesperado.');
    }
  }

  Future<bool> refreshToken() async {
    try {
      final refresh = await secureStorage.getRefreshToken();
      if (refresh == null) return false;

      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh-token': refresh}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        await secureStorage.saveJwt(body['access_token'] as String);
        return true;
      }
      return false;
    } catch (e) {
      log('Falha ao renovar token', error: e, name: 'AuthService');
      return false;
    }
  }

  Future<void> logout() async {
    await secureStorage.clearAll();
  }
}
