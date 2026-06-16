import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';

void main() {
  group('ColetaModel.fromJson', () {
    final Map<String, dynamic> baseJson = {
      'uuid': 'coleta-123',
      'usuario_id': 'user-456',
      'data_coleta': '2023-10-27T10:00:00Z',
      'status_sincronizacao': 'pendente',
      'nome_bem': 'Sítio Teste',
      'versao': 1,
      'updated_at': '2023-10-27T10:00:00Z',
      'dados_coletados': <String, dynamic>{},
    };

    test('fromJson com localizacao aninhada extrai lat e lng corretamente', () {
      // Arrange
      final json = <String, dynamic>{
        ...baseJson,
        'localizacao': <String, dynamic>{
          'id': 'loc-1',
          'lat': -3.9264,
          'lng': -41.4683,
        },
      };

      // Act
      final model = ColetaModel.fromJson(json);

      // Assert
      check(model.localizacao)
        ..isNotNull()
        ..has((l) => l!.lat, 'lat').equals(-3.9264)
        ..has((l) => l!.lng, 'lng').equals(-41.4683);
    });

    test('fromJson sem localizacao usa latitude/longitude da raiz', () {
      // Arrange
      final json = <String, dynamic>{
        ...baseJson,
        'latitude': -3.9264,
        'longitude': -41.4683,
      };

      // Act
      final model = ColetaModel.fromJson(json);

      // Assert
      check(model.localizacao)
        ..isNotNull()
        ..has((l) => l!.lat, 'lat').equals(-3.9264)
        ..has((l) => l!.lng, 'lng').equals(-41.4683);
    });

    test('fromJson sem nenhuma coordenada resulta em localizacao nula', () {
      // Arrange
      final json = Map<String, dynamic>.from(baseJson);

      // Act
      final model = ColetaModel.fromJson(json);

      // Assert
      check(model.localizacao).isNull();
    });
  });
}
