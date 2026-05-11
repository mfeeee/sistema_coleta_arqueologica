import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/services/auth_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';

class _FakeSecureStorage extends SecureStorageService {
  _FakeSecureStorage() : super(const FlutterSecureStorage());

  String? tokenSalvo;

  @override
  Future<void> saveJwt(String token) async => tokenSalvo = token;

  @override
  Future<String?> getJwt() async => tokenSalvo;

  @override
  Future<void> clearAll() async => tokenSalvo = null;
}

class _FakeHttpClient extends http.BaseClient {
  _FakeHttpClient(this._handler);

  final Future<http.Response> Function(http.BaseRequest) _handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final resp = await _handler(request);
    return http.StreamedResponse(
      Stream.value(resp.bodyBytes),
      resp.statusCode,
      headers: resp.headers,
    );
  }
}

_FakeHttpClient _clienteComResposta(
  int statusCode,
  Map<String, dynamic> corpo,
) => _FakeHttpClient((_) async => http.Response(jsonEncode(corpo), statusCode));

_FakeHttpClient _clienteLancando(Object excecao) =>
    _FakeHttpClient((_) async => throw excecao);

void main() {
  late _FakeSecureStorage armazenamento;
  late AuthService authService;

  const baseUrl = 'http://localhost';

  setUp(() {
    armazenamento = _FakeSecureStorage();
  });

  AuthService criarServico(http.Client cliente) => AuthService(
    secureStorage: armazenamento,
    httpClient: cliente,
    baseUrl: baseUrl,
  );

  group('AuthService.register', () {
    test('sucesso 201: armazena token e retorna AuthSuccess', () async {
      authService = criarServico(
        _clienteComResposta(201, {
          'token': 'token-abc-123',
          'user': {'name': 'João Silva', 'id': '42'},
        }),
      );

      final resultado = await authService.register(
        name: 'João Silva',
        email: 'joao@example.com',
        password: 'senha12345',
        classificacao: 'estudante',
      );

      expect(resultado, isA<AuthSuccess>());
      expect((resultado as AuthSuccess).userName, 'João Silva');
      expect(armazenamento.tokenSalvo, 'token-abc-123');
    });

    test('falha 422: retorna mensagem de validação do servidor', () async {
      authService = criarServico(
        _clienteComResposta(422, {
          'errors': {
            'email': ['O e-mail já está em uso.'],
          },
        }),
      );

      final resultado = await authService.register(
        name: 'João Silva',
        email: 'existente@example.com',
        password: 'senha12345',
        classificacao: 'estudante',
      );

      expect(resultado, isA<AuthFailure>());
      expect((resultado as AuthFailure).message, 'O e-mail já está em uso.');
    });

    test('sem conexão: retorna mensagem amigável de rede', () async {
      authService = criarServico(
        _clienteLancando(const SocketException('Sem rede')),
      );

      final resultado = await authService.register(
        name: 'João Silva',
        email: 'joao@example.com',
        password: 'senha12345',
        classificacao: 'estudante',
      );

      expect(resultado, isA<AuthFailure>());
      expect((resultado as AuthFailure).message, TratadorDeErros.semConexao);
    });

    test('timeout: retorna mensagem amigável de timeout', () async {
      authService = criarServico(_clienteLancando(TimeoutException('timeout')));

      final resultado = await authService.register(
        name: 'João Silva',
        email: 'joao@example.com',
        password: 'senha12345',
        classificacao: 'estudante',
      );

      expect(resultado, isA<AuthFailure>());
      expect((resultado as AuthFailure).message, TratadorDeErros.timeout);
    });

    test('token ausente na resposta 201: retorna AuthFailure', () async {
      authService = criarServico(
        _clienteComResposta(201, {'user': 'sem token'}),
      );

      final resultado = await authService.register(
        name: 'João',
        email: 'joao@example.com',
        password: 'senha12345',
        classificacao: 'estudante',
      );

      expect(resultado, isA<AuthFailure>());
      expect(armazenamento.tokenSalvo, isNull);
    });
  });

  group('AuthService.login', () {
    test('sucesso 200: armazena token e retorna AuthSuccess', () async {
      authService = criarServico(
        _clienteComResposta(200, {
          'token': 'jwt-login-456',
          'user': {'name': 'Maria Souza', 'id': '7'},
        }),
      );

      final resultado = await authService.login(
        'maria@example.com',
        'senha12345',
      );

      expect(resultado, isA<AuthSuccess>());
      expect((resultado as AuthSuccess).userName, 'Maria Souza');
      expect(armazenamento.tokenSalvo, 'jwt-login-456');
    });

    test('credenciais inválidas 401: retorna mensagem correta', () async {
      authService = criarServico(
        _clienteComResposta(401, {'message': 'Unauthenticated.'}),
      );

      final resultado = await authService.login(
        'errado@example.com',
        'senha-errada',
      );

      expect(resultado, isA<AuthFailure>());
      expect(
        (resultado as AuthFailure).message,
        TratadorDeErros.credenciaisInvalidas,
      );
    });

    test('sem conexão: retorna mensagem amigável de rede', () async {
      authService = criarServico(
        _clienteLancando(const SocketException('Sem rede')),
      );

      final resultado = await authService.login(
        'joao@example.com',
        'senha12345',
      );

      expect(resultado, isA<AuthFailure>());
      expect((resultado as AuthFailure).message, TratadorDeErros.semConexao);
    });

    test('conta desativada 403: retorna mensagem correta', () async {
      authService = criarServico(
        _clienteComResposta(403, {'message': 'Forbidden.'}),
      );

      final resultado = await authService.login(
        'bloqueado@example.com',
        'senha12345',
      );

      expect(resultado, isA<AuthFailure>());
      expect(
        (resultado as AuthFailure).message,
        TratadorDeErros.contaDesativada,
      );
    });
  });
}
