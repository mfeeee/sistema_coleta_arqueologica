import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/entities/sync_resumo.dart';

/// Responde a qualquer requisição com o status e o corpo dados.
class _AdaptadorFalso implements HttpClientAdapter {
  _AdaptadorFalso(this.status, this.corpo);

  final int status;
  final Map<String, dynamic> corpo;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(corpo),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  test('422 de validação guarda o erro do campo, não o resumo', () async {
    // Arrange
    final dio = Dio(BaseOptions(baseUrl: 'https://api.teste'))
      ..httpClientAdapter = _AdaptadorFalso(422, {
        'message': 'Erro de validação.',
        'errors': {
          'coletas.0.localizacao.cep': [
            'O campo CEP não deve ter mais de 9 caracteres.',
          ],
        },
      });
    final coleta = ColetaModel(
      id: 'c1',
      usuarioId: 'u1',
      nomeBem: 'Bem',
      dataColeta: DateTime(2026),
      updatedAt: DateTime(2026),
      versao: 1,
      syncStatus: StatusColeta.pendente,
      artefatoTipos: const [],
      dadosColetados: const {},
    );

    // Act
    final resultado = await SyncApiDatasourceImpl(
      dio,
    ).enviarColeta(coleta: coleta);

    // Assert
    expect(resultado.status, SyncResultStatus.recusada);
    expect(
      resultado.mensagem,
      'O campo CEP não deve ter mais de 9 caracteres.',
    );
  });
}
