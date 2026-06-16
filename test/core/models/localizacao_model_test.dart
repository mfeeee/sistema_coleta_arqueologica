import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/models/localizacao_model.dart';

void main() {
  group('LocalizacaoModel.fromJson', () {
    test('deve preferir lat/lng diretos se presentes', () {
      final json = {
        'id': '1',
        'lat': -5.0,
        'lng': -40.0,
        'geom': 'POINT(-41.0 -6.0)',
      };

      final model = LocalizacaoModel.fromJson(json);

      expect(model.lat, -5.0);
      expect(model.lng, -40.0);
    });

    test('deve usar geom como Map se lat/lng diretos estiverem ausentes', () {
      final json = {
        'id': '1',
        'geom': {'lat': -5.0, 'lng': -40.0},
      };

      final model = LocalizacaoModel.fromJson(json);

      expect(model.lat, -5.0);
      expect(model.lng, -40.0);
    });

    test(
      'deve fazer fallback para WKT se lat/lng diretos e Map geom estiverem ausentes',
      () {
        final json = {'id': '1', 'geom': 'POINT(-41.0 -6.0)'};

        final model = LocalizacaoModel.fromJson(json);

        expect(model.lat, -6.0);
        expect(model.lng, -41.0);
      },
    );

    test('deve retornar null se nada for encontrado', () {
      final json = {'id': '1'};

      final model = LocalizacaoModel.fromJson(json);

      expect(model.lat, isNull);
      expect(model.lng, isNull);
    });
  });

  group('LocalizacaoModel.toJson', () {
    test('deve converter para geom Map e remover lat/lng da raiz', () {
      const model = LocalizacaoModel(id: '1', lat: -5.0, lng: -40.0);

      final json = model.toJson();

      expect(json['geom'], {'lat': -5.0, 'lng': -40.0});
      expect(json.containsKey('lat'), isFalse);
      expect(json.containsKey('lng'), isFalse);
    });
  });
}
