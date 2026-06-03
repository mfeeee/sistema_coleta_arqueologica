import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/entities/sync_resumo.dart';

void main() {
  group('SyncResumo.totalOk', () {
    test('retorna true quando conflitos e erros são zero', () {
      // Arrange
      const resumo = SyncResumo(sucessos: 5, conflitos: 0, erros: 0);

      // Act & Assert
      check(resumo.totalOk).isTrue();
    });

    test('retorna false quando há conflitos', () {
      const resumo = SyncResumo(sucessos: 3, conflitos: 1, erros: 0);

      check(resumo.totalOk).isFalse();
    });

    test('retorna false quando há erros', () {
      const resumo = SyncResumo(sucessos: 3, conflitos: 0, erros: 2);

      check(resumo.totalOk).isFalse();
    });

    test('retorna false quando há conflitos e erros', () {
      const resumo = SyncResumo(sucessos: 1, conflitos: 1, erros: 1);

      check(resumo.totalOk).isFalse();
    });
  });

  group('SyncResumo.total', () {
    test('soma sucessos, conflitos e erros corretamente', () {
      const resumo = SyncResumo(sucessos: 3, conflitos: 2, erros: 1);

      check(resumo.total).equals(6);
    });

    test('retorna zero quando todos os campos são zero', () {
      const resumo = SyncResumo(sucessos: 0, conflitos: 0, erros: 0);

      check(resumo.total).equals(0);
    });

    test('retorna apenas sucessos quando não há falhas', () {
      const resumo = SyncResumo(sucessos: 10, conflitos: 0, erros: 0);

      check(resumo.total).equals(10);
    });
  });
}
