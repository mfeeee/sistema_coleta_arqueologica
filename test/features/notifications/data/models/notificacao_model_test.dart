import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/features/notifications/data/models/notificacao_model.dart';

void main() {
  group('NotificacaoModel', () {
    final now = DateTime.now();
    final json = {
      'id': '1',
      'titulo': 'Teste',
      'corpo': 'Corpo do teste',
      'tipo': 'info',
      'lida': false,
      'lida_em': null,
      'created_at': now.toIso8601String(),
    };

    final model = NotificacaoModel(
      id: '1',
      titulo: 'Teste',
      corpo: 'Corpo do teste',
      tipo: 'info',
      lida: false,
      lidaEm: null,
      createdAt: now,
    );

    test('fromJson cria instância correta', () {
      final result = NotificacaoModel.fromJson(json);
      check(result.id).equals('1');
      check(result.titulo).equals('Teste');
      check(result.corpo).equals('Corpo do teste');
      check(result.tipo).equals('info');
      check(result.lida).isFalse();
      check(result.lidaEm).isNull();
      // Comparação de DateTime com precisão de milissegundos para evitar falhas por micro-ajustes
      check(result.createdAt.toIso8601String()).equals(now.toIso8601String());
    });

    test('toJson retorna mapa correto', () {
      final result = model.toJson();
      check(result['id']).equals('1');
      check(result['titulo']).equals('Teste');
      check(result['corpo']).equals('Corpo do teste');
      check(result['tipo']).equals('info');
      check(result['lida']).equals(false);
      check(result['lida_em']).isNull();
      check(result['created_at']).equals(now.toIso8601String());
    });

    test('copyWith funciona corretamente', () {
      final updated = model.copyWith(
        id: '2',
        titulo: 'Novo Titulo',
        corpo: 'Novo Corpo',
        tipo: 'alerta',
        lida: true,
        lidaEm: now,
        createdAt: now,
      );
      check(updated.id).equals('2');
      check(updated.titulo).equals('Novo Titulo');
      check(updated.corpo).equals('Novo Corpo');
      check(updated.tipo).equals('alerta');
      check(updated.lida).isTrue();
      check(updated.lidaEm).equals(now);
      check(updated.createdAt).equals(now);

      final partiallyUpdated = model.copyWith(titulo: 'Apenas Titulo');
      check(partiallyUpdated.titulo).equals('Apenas Titulo');
      check(partiallyUpdated.id).equals(model.id);

      final emptyUpdate = model.copyWith();
      check(emptyUpdate.id).equals(model.id);
    });
  });

  group('PreferenciasNotificacaoModel', () {
    final json = {
      'push_enabled': true,
      'email_enabled': false,
      'tipos_habilitados': ['info', 'alerta'],
    };

    const model = PreferenciasNotificacaoModel(
      pushEnabled: true,
      emailEnabled: false,
      tiposHabilitados: ['info', 'alerta'],
    );

    test('fromJson cria instância correta', () {
      final result = PreferenciasNotificacaoModel.fromJson(json);
      check(result.pushEnabled).isTrue();
      check(result.emailEnabled).isFalse();
      check(result.tiposHabilitados).deepEquals(['info', 'alerta']);
    });

    test('toJson retorna mapa correto', () {
      final result = model.toJson();
      check(result['push_enabled']).equals(true);
      check(result['email_enabled']).equals(false);
      check(result['tipos_habilitados'] as List).deepEquals(['info', 'alerta']);
    });

    test('copyWith funciona corretamente', () {
      final updated = model.copyWith(pushEnabled: false);
      check(updated.pushEnabled).isFalse();
      check(updated.emailEnabled).equals(model.emailEnabled);
      check(updated.tiposHabilitados).deepEquals(model.tiposHabilitados);

      final emptyUpdate = model.copyWith();
      check(emptyUpdate.pushEnabled).equals(model.pushEnabled);
    });
  });
}
