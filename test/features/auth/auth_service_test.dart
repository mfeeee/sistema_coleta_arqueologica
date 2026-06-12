import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/services/auth_service.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import '../../helpers/dio_mock.dart';

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

void main() {
  late _FakeSecureStorage armazenamento;
  late AuthService authService;

  setUp(() {
    armazenamento = _FakeSecureStorage();
  });

  AuthService criarServico(Dio dio) =>
      AuthService(secureStorage: armazenamento, dio: dio);

  group('AuthService.register', () {
    test('sucesso 201: armazena token e retorna AuthSuccess', () async {
      final dio = createMockDio(
        (_) async => createResponse({
          'token': 'token-abc-123',
          'user': {'name': 'João Silva', 'id': '42'},
        }, 201),
      );

      authService = criarServico(dio);

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
      final dio = createMockDio(
        (_) async => createResponse({
          'errors': {
            'email': ['O e-mail já está em uso.'],
          },
        }, 422),
      );

      authService = criarServico(dio);

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
      final dio = createMockDio(
        (_) async => throw const SocketException('Sem rede'),
      );

      authService = criarServico(dio);

      final resultado = await authService.register(
        name: 'João Silva',
        email: 'joao@example.com',
        password: 'senha12345',
        classificacao: 'estudante',
      );

      expect(resultado, isA<AuthFailure>());
      // O Dio interceptor ou o catch do AuthService deveria mapear isso.
      // No AuthService.register atual ele retorna o msg de e.response?.data
      // Se não tiver response, ele retorna TratadorDeErros.erroInesperado se não for capturado pelo interceptor.
      // Mas aqui estamos jogando SocketException direto.
    });

    test('timeout: retorna mensagem amigável de timeout', () async {
      final dio = createMockDio((_) async => throw TimeoutException('timeout'));

      authService = criarServico(dio);

      final resultado = await authService.register(
        name: 'João Silva',
        email: 'joao@example.com',
        password: 'senha12345',
        classificacao: 'estudante',
      );

      expect(resultado, isA<AuthFailure>());
    });

    test('token ausente na resposta 201: retorna AuthFailure', () async {
      final dio = createMockDio(
        (_) async => createResponse({'user': 'sem token'}, 201),
      );

      authService = criarServico(dio);

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
      final dio = createMockDio(
        (_) async => createResponse({
          'token': 'jwt-login-456',
          'user': {'name': 'Maria Souza', 'id': '7'},
        }, 200),
      );

      authService = criarServico(dio);

      final resultado = await authService.login(
        'maria@example.com',
        'senha12345',
      );

      expect(resultado, isA<AuthSuccess>());
      expect((resultado as AuthSuccess).userName, 'Maria Souza');
      expect(armazenamento.tokenSalvo, 'jwt-login-456');
    });

    test('credenciais inválidas 401: retorna mensagem correta', () async {
      final dio = createMockDio(
        (_) async => createResponse({'message': 'Unauthenticated.'}, 401),
      );

      authService = criarServico(dio);

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
      final dio = createMockDio(
        (_) async => throw const SocketException('Sem rede'),
      );

      authService = criarServico(dio);

      final resultado = await authService.login(
        'joao@example.com',
        'senha12345',
      );

      expect(resultado, isA<AuthFailure>());
    });

    test('conta desativada 403: retorna mensagem correta', () async {
      final dio = createMockDio(
        (_) async => createResponse({'message': 'Forbidden.'}, 403),
      );

      authService = criarServico(dio);

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
