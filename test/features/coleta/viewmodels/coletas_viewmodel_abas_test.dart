import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_curadoria.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coletas_viewmodel.dart';

class _RepositorioFalso extends Fake implements ColetaRepository {}

ColetaEntity _coleta(
  String id,
  StatusColeta status, [
  StatusCuradoria? curadoria,
]) => ColetaEntity(
  id: id,
  usuarioId: 'u1',
  dataColeta: DateTime(2026),
  syncStatus: status,
  nomeBem: id,
  artefatoTipos: const [],
  versao: 1,
  updatedAt: DateTime(2026),
  dadosColetados: const {},
  curadoriaStatus: curadoria,
);

void main() {
  test('abas seguem a decisão da curadoria, não o estado de envio', () {
    // Arrange
    final vm = ColetasViewModel(_RepositorioFalso());
    vm.coletas.value = [
      _coleta('rascunho', StatusColeta.rascunho),
      _coleta('nao-enviada', StatusColeta.pendente),
      _coleta('em-analise', StatusColeta.sincronizado),
      _coleta('aprovada', StatusColeta.sincronizado, StatusCuradoria.aprovado),
      _coleta(
        'rejeitada',
        StatusColeta.sincronizado,
        StatusCuradoria.rejeitado,
      ),
      _coleta('recusada', StatusColeta.conflito),
    ];

    // Act
    List<String> ids(List<ColetaEntity> lista) =>
        lista.map((c) => c.id).toList();

    // Assert
    expect(ids(vm.aguardandoDecisao), ['nao-enviada', 'em-analise']);
    expect(ids(vm.aprovadas), ['aprovada']);
    expect(ids(vm.rejeitadas), ['rejeitada', 'recusada']);
  });
}
