import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_curadoria.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/services/envio_curadoria_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';

/// Responde a qualquer requisição com o status e o corpo dados.
class _AdaptadorFalso implements HttpClientAdapter {
  _AdaptadorFalso(this.status, this.corpo);

  final int status;
  final Map<String, dynamic> corpo;
  RequestOptions? ultima;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    ultima = options;
    return ResponseBody.fromString(
      jsonEncode(corpo),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _RepositorioFalso extends Fake implements ColetaRepository {
  ColetaEntity? salva;

  @override
  Future<void> salvar(ColetaEntity coleta) async => salva = coleta;
}

EnvioCuradoriaService _servico(
  _AdaptadorFalso adaptador,
  _RepositorioFalso repositorio,
) => EnvioCuradoriaService(
  dio: Dio(BaseOptions(baseUrl: 'https://api.teste'))
    ..httpClientAdapter = adaptador,
  coletaRepository: repositorio,
);

void main() {
  test('enviar grava a coleta como em curadoria', () async {
    // Arrange
    final adaptador = _AdaptadorFalso(200, {
      'data': {
        'uuid': 'c1',
        'usuario_id': 'u1',
        'data_coleta': '2026-01-01T00:00:00Z',
        'status_sincronizacao': 'sincronizado',
        'curadoria': {'status': 'pendente', 'observacao': null},
      },
    });
    final repositorio = _RepositorioFalso();

    // Act
    final erro = await _servico(adaptador, repositorio).enviar('c1');

    // Assert
    expect(erro, isNull);
    expect(adaptador.ultima?.path, '/v1/mobile/coletas/c1/enviar-curadoria');
    expect(repositorio.salva?.curadoriaStatus, StatusCuradoria.pendente);
  });

  test('recusa da API devolve a mensagem e não grava nada', () async {
    // Arrange
    final adaptador = _AdaptadorFalso(409, {
      'message': 'A coleta já foi enviada para curadoria.',
    });
    final repositorio = _RepositorioFalso();

    // Act
    final erro = await _servico(adaptador, repositorio).enviar('c1');

    // Assert
    expect(erro, 'A coleta já foi enviada para curadoria.');
    expect(repositorio.salva, isNull);
  });
}
