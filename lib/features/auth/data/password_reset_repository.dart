import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';

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
  PasswordResetRepository({required this.dio});

  final Dio dio;

  Future<RequestResetResult> requestReset(String email) async {
    try {
      final response = await dio.post(
        '/auth/password-reset',
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 404) {
        return const RequestResetSucesso();
      }

      final body = response.data as Map<String, dynamic>? ?? {};
      return RequestResetFalha(_extrairMensagem(body));
    } on DioException catch (e) {
      final body = e.response?.data as Map<String, dynamic>? ?? {};
      return RequestResetFalha(_extrairMensagem(body));
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
    String email,
    String token,
    String novaSenha,
  ) async {
    try {
      final response = await dio.post(
        '/auth/password-reset/confirm',
        data: {
          'email': email,
          'token': token,
          'password': novaSenha,
          'password_confirmation': novaSenha,
        },
      );

      if (response.statusCode == 200) return const ConfirmResetSucesso();

      final body = response.data as Map<String, dynamic>? ?? {};
      return ConfirmResetFalha(_extrairMensagem(body));
    } on DioException catch (e) {
      final body = e.response?.data as Map<String, dynamic>? ?? {};
      return ConfirmResetFalha(_extrairMensagem(body));
    } catch (e) {
      log(
        'Erro desconhecido em confirmReset',
        error: e,
        name: 'PasswordResetRepository',
      );
      return const ConfirmResetFalha(TratadorDeErros.erroInesperado);
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
