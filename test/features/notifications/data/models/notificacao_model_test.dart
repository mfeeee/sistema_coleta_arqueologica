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
    final json = {'coleta': true, 'sync': false, 'sistema': true, 'push': true};

    const model = PreferenciasNotificacaoModel(
      coleta: true,
      sync: false,
      sistema: true,
      push: true,
    );

    test('fromJson cria instância correta', () {
      final result = PreferenciasNotificacaoModel.fromJson(json);
      check(result.coleta).isTrue();
      check(result.sync).isFalse();
      check(result.sistema).isTrue();
      check(result.push).isTrue();
    });

    test('toJson retorna mapa correto', () {
      final result = model.toJson();
      check(result['coleta']).equals(true);
      check(result['sync']).equals(false);
      check(result['sistema']).equals(true);
      check(result['push']).equals(true);
    });

    test('copyWith funciona corretamente', () {
      final updated = model.copyWith(coleta: false);
      check(updated.coleta).isFalse();
      check(updated.sync).equals(model.sync);
      check(updated.sistema).equals(model.sistema);
      check(updated.push).equals(model.push);

      final emptyUpdate = model.copyWith();
      check(emptyUpdate.coleta).equals(model.coleta);
    });
  });
}
