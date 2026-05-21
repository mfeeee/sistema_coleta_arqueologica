import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_coleta_arqueologica/core/errors/arqueo_exceptions.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/datasources/coleta_api_datasource.dart';
import '../../helpers/fakes/fake_secure_storage_service.dart';

// ---------------------------------------------------------------------------
// Fake HTTP client
// ---------------------------------------------------------------------------

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

_FakeHttpClient _clienteLancando(Object excecao) =>
    _FakeHttpClient((_) async => throw excecao);

_FakeHttpClient _clienteComStatus(int status) =>
    _FakeHttpClient((_) async => http.Response('{"data":[]}', status));

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Future<ColetaApiDatasourceImpl> _criarDatasource(http.Client client) async {
  final armazenamento = FakeSecureStorageService();
  await armazenamento.saveJwt('token-teste');
  return ColetaApiDatasourceImpl(
    httpClient: client,
    secureStorage: armazenamento,
    baseUrl: 'http://localhost',
  );
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('ColetaApiDatasource.fetchMinhas — erros de rede', () {
    test('TimeoutException lança ErroDeRede', () async {
      final ds = await _criarDatasource(
        _clienteLancando(TimeoutException('timeout')),
      );

      expect(ds.fetchMinhas, throwsA(isA<ErroDeRede>()));
    });

    test('SocketException lança ErroDeRede', () async {
      final ds = await _criarDatasource(
        _clienteLancando(const SocketException('sem rede')),
      );

      expect(ds.fetchMinhas, throwsA(isA<ErroDeRede>()));
    });

    test('ClientException lança ErroDeRede', () async {
      final ds = await _criarDatasource(
        _clienteLancando(http.ClientException('falha http')),
      );

      expect(ds.fetchMinhas, throwsA(isA<ErroDeRede>()));
    });
  });

  group('ColetaApiDatasource.fetchMinhas — erros de autorização', () {
    test('resposta 401 lança ErroDeAutorizacao', () async {
      final ds = await _criarDatasource(_clienteComStatus(401));

      expect(ds.fetchMinhas, throwsA(isA<ErroDeAutorizacao>()));
    });

    test('resposta 403 lança ErroDeAutorizacao', () async {
      final ds = await _criarDatasource(_clienteComStatus(403));

      expect(ds.fetchMinhas, throwsA(isA<ErroDeAutorizacao>()));
    });

    test('sem token armazenado lança ErroDeAutorizacao', () async {
      final armazenamentoVazio = FakeSecureStorageService();
      final ds = ColetaApiDatasourceImpl(
        httpClient: _FakeHttpClient((_) async => throw UnimplementedError()),
        secureStorage: armazenamentoVazio,
        baseUrl: 'http://localhost',
      );

      expect(ds.fetchMinhas, throwsA(isA<ErroDeAutorizacao>()));
    });
  });

  group('ColetaApiDatasource.fetchMinhas — erros de servidor', () {
    test('resposta 500 lança ErroDeServidor', () async {
      final ds = await _criarDatasource(_clienteComStatus(500));

      expect(ds.fetchMinhas, throwsA(isA<ErroDeServidor>()));
    });

    test('resposta 503 lança ErroDeServidor', () async {
      final ds = await _criarDatasource(_clienteComStatus(503));

      expect(ds.fetchMinhas, throwsA(isA<ErroDeServidor>()));
    });
  });

  group('ColetaApiDatasource.fetchMinhas — sucesso', () {
    test('resposta 200 com lista vazia retorna lista vazia', () async {
      final ds = await _criarDatasource(_clienteComStatus(200));

      final resultado = await ds.fetchMinhas();

      expect(resultado, isEmpty);
    });
  });
}
