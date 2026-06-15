import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:sistema_coleta_arqueologica/core/errors/auth_exceptions.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import 'secure_storage_service.dart';

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
    this.avatarUrl,
  });
  final String userName;
  final String userId;
  final String? email;
  final String? classificacao;
  final String? avatarUrl;
}

final class AuthFailure extends AuthResult {
  const AuthFailure(this.message);
  final String message;
}

class AuthService {
  AuthService({required this.secureStorage, required this.dio});

  final SecureStorageService secureStorage;
  final Dio dio;

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final body = response.data as Map<String, dynamic>;
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
        avatarUrl: user?['avatar_url'] as String?,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final body = e.response?.data as Map<String, dynamic>?;
        final msg = body?['message'] as String?;
        if (msg != null &&
            (msg.toLowerCase().contains('deactivated') ||
                msg.toLowerCase().contains('desativada'))) {
          return const AuthFailure(TratadorDeErros.contaDesativada);
        }
        return const AuthFailure(TratadorDeErros.credenciaisInvalidas);
      }
      if (e.response?.statusCode == 403) {
        return const AuthFailure(TratadorDeErros.contaDesativada);
      }
      final body = e.response?.data as Map<String, dynamic>?;
      final msg = body?['message'] as String?;
      return AuthFailure(msg ?? TratadorDeErros.erroInesperado);
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
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'classificacao': classificacao,
        },
      );

      final body = response.data as Map<String, dynamic>;
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
        avatarUrl: null,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final body = e.response?.data as Map<String, dynamic>?;
        final errors = body?['errors'] as Map<String, dynamic>?;
        final first = errors?.values.first;
        final msg = (first is List && first.isNotEmpty)
            ? first.first as String
            : TratadorDeErros.erroInesperado;
        return AuthFailure(msg);
      }
      final body = e.response?.data as Map<String, dynamic>?;
      final msg = body?['message'] as String?;
      return AuthFailure(msg ?? TratadorDeErros.erroInesperado);
    } catch (e) {
      log('Erro desconhecido no registro', error: e, name: 'AuthService');
      return const AuthFailure(TratadorDeErros.erroInesperado);
    }
  }

  Future<RecuperacaoResult> solicitarRecuperacaoSenha(String email) async {
    try {
      final response = await dio.post(
        '/auth/password-reset',
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 404) {
        return const RecuperacaoSucesso();
      }

      final body = response.data as Map<String, dynamic>;
      final msg = body['message'] as String?;
      return RecuperacaoFalha(msg ?? TratadorDeErros.erroInesperado);
    } catch (e) {
      log('Erro na recuperação de senha', error: e, name: 'AuthService');
      return const RecuperacaoFalha(TratadorDeErros.erroInesperado);
    }
  }

  Future<bool> renovarToken() async {
    try {
      final token = await secureStorage.getJwt();
      if (token == null) return false;

      final response = await dio.post(
        '/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) return false;

      final body = response.data as Map<String, dynamic>;
      final novoToken = body['token'] as String?;
      if (novoToken == null) return false;

      await secureStorage.saveJwt(novoToken);
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final body = e.response?.data as Map<String, dynamic>?;
        final msg = body?['message'] as String?;
        if (msg != null &&
            (msg.toLowerCase().contains('deactivated') ||
                msg.toLowerCase().contains('desativada'))) {
          throw const AccountDeactivatedException(
            TratadorDeErros.contaDesativada,
          );
        }
      }
      log('Erro ao renovar token', error: e, name: 'AuthService');
      return false;
    } catch (e) {
      log('Erro ao renovar token', error: e, name: 'AuthService');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final token = await secureStorage.getJwt();
      if (token != null) {
        await dio.post(
          '/auth/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (e) {
      log('Falha ao chamar /auth/logout', error: e, name: 'AuthService');
    } finally {
      await secureStorage.clearAll();
    }
  }
}
