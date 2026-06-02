import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';

const _kTimeoutRequisicao = Duration(seconds: 15);

sealed class ProfileResult {
  const ProfileResult();
}

final class ProfileSuccess extends ProfileResult {
  const ProfileSuccess(this.data);
  final Map<String, dynamic> data;
}

final class ProfileFailure extends ProfileResult {
  const ProfileFailure(this.message);
  final String message;
}

class ProfileService {
  ProfileService({required this.httpClient, required this.baseUrl});

  final http.Client httpClient;
  final String baseUrl;

  static const _kHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<ProfileResult> fetchMe() async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/auth/me'), headers: _kHeaders)
          .timeout(_kTimeoutRequisicao);
      return _processar(response);
    } catch (e, st) {
      return _falha(e, st, 'fetchMe');
    }
  }

  Future<ProfileResult> updateProfile({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? classificacao,
  }) async {
    final payload = <String, String>{};
    if (name != null) payload['name'] = name;
    if (email != null) payload['email'] = email;
    if (password != null) payload['password'] = password;
    if (passwordConfirmation != null) {
      payload['password_confirmation'] = passwordConfirmation;
    }
    if (classificacao != null) payload['classificacao'] = classificacao;
    try {
      final response = await httpClient
          .patch(
            Uri.parse('$baseUrl/auth/me'),
            headers: _kHeaders,
            body: jsonEncode(payload),
          )
          .timeout(_kTimeoutRequisicao);
      return _processar(response);
    } catch (e, st) {
      return _falha(e, st, 'updateProfile');
    }
  }

  Future<ProfileResult> uploadAvatar(File avatarFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/auth/me/avatar'),
      );
      request.headers['Accept'] = 'application/json';
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatarFile.path),
      );
      final streamed = await httpClient
          .send(request)
          .timeout(_kTimeoutRequisicao);
      final response = await http.Response.fromStream(streamed);
      return _processar(response);
    } catch (e, st) {
      return _falha(e, st, 'uploadAvatar');
    }
  }

  Future<ProfileResult> deleteAvatar() async {
    try {
      final response = await httpClient
          .delete(Uri.parse('$baseUrl/auth/me/avatar'), headers: _kHeaders)
          .timeout(_kTimeoutRequisicao);
      return _processar(response);
    } catch (e, st) {
      return _falha(e, st, 'deleteAvatar');
    }
  }

  ProfileResult _processar(http.Response response) {
    if (response.statusCode == 204) return const ProfileSuccess({});
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return switch (response.statusCode) {
      200 || 201 => ProfileSuccess(body),
      422 => ProfileFailure(_erros422(body)),
      _ => ProfileFailure(
        body['message'] as String? ?? TratadorDeErros.erroInesperado,
      ),
    };
  }

  String _erros422(Map<String, dynamic> body) {
    final errors = body['errors'] as Map<String, dynamic>?;
    final first = errors?.values.first;
    if (first is List && first.isNotEmpty) return first.first as String;
    return body['message'] as String? ?? TratadorDeErros.erroInesperado;
  }

  ProfileFailure _falha(Object e, StackTrace st, String operacao) {
    log('Erro em $operacao', error: e, stackTrace: st, name: 'ProfileService');
    return ProfileFailure(TratadorDeErros.deExcecao(e));
  }
}
