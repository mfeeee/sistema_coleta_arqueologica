import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/data/models/coleta_model.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coletas_viewmodel.dart';
import '../../helpers/fakes/fake_coleta_repository.dart';

final _data = DateTime(2024);

ColetaModel _coleta(String id, StatusColeta status) => ColetaModel(
  id: id,
  usuarioId: 'u1',
  nomeBem: 'Bem $id',
  latitude: -2.9,
  longitude: -41.7,
  dataColeta: _data,
  updatedAt: _data,
  versao: 1,
  syncStatus: status,
  artefatos: [ArtefatoBem.ceramica],
  dadosColetados: {},
);

void main() {
  group('ColetaEntity — sem campo sincronizado booleano', () {
    test('instância com syncStatus sincronizado compila sem campo bool', () {
      final entidade = ColetaEntity(
        id: 'e1',
        usuarioId: 'u1',
        nomeBem: 'Sítio X',
        latitude: -2.9,
        longitude: -41.7,
        dataColeta: _data,
        updatedAt: _data,
        versao: 1,
        syncStatus: StatusColeta.sincronizado,
        artefatos: const [],
        dadosColetados: const {},
      );

      expect(entidade.syncStatus, StatusColeta.sincronizado);
    });

    test('ColetaModel.fromJson mapeia status_sincronizacao corretamente', () {
      final json = {
        'uuid': 'j1',
        'usuario_id': 'u1',
        'data_coleta': '2024-01-01T00:00:00.000',
        'updated_at': '2024-01-01T00:00:00.000',
        'status_sincronizacao': 'sincronizado',
        'nome_bem': 'Bem JSON',
        'latitude': -2.9,
        'longitude': -41.7,
        'artefatos': [],
        'versao': 1,
        'dados_coletados': <String, dynamic>{},
      };

      final model = ColetaModel.fromJson(json);

      expect(model.syncStatus, StatusColeta.sincronizado);
    });

    test(
      'ColetaModel.fromJson com status ausente usa pendente como padrão',
      () {
        final json = {
          'uuid': 'j2',
          'usuario_id': 'u1',
          'data_coleta': '2024-01-01T00:00:00.000',
          'updated_at': '2024-01-01T00:00:00.000',
          'nome_bem': 'Bem JSON',
          'latitude': -2.9,
          'longitude': -41.7,
          'artefatos': [],
          'versao': 1,
          'dados_coletados': <String, dynamic>{},
        };

        final model = ColetaModel.fromJson(json);

        expect(model.syncStatus, StatusColeta.pendente);
      },
    );

    test('ColetaModel.fromEntity preserva syncStatus sem campo bool', () {
      final origem = _coleta('src', StatusColeta.sincronizado);
      final copia = ColetaModel.fromEntity(origem);

      expect(copia.syncStatus, StatusColeta.sincronizado);
      expect(copia.id, origem.id);
    });
  });

  group('ColetasViewModel — getters de progresso usam apenas syncStatus', () {
    test('sincronizadas retorna coletas com syncStatus sincronizado', () {
      final coletas = [
        _coleta('a', StatusColeta.pendente),
        _coleta('b', StatusColeta.sincronizado),
        _coleta('c', StatusColeta.sincronizado),
        _coleta('d', StatusColeta.conflito),
      ];

      final vm = ColetasViewModel(FakeColetaRepository(coletas));
      vm.coletas.value = coletas;

      expect(vm.sincronizadas, hasLength(2));
      expect(vm.sincronizadas.map((e) => e.id), containsAll(['b', 'c']));

      vm.dispose();
    });

    test('pendentes retorna apenas coletas com syncStatus pendente', () {
      final coletas = [
        _coleta('p1', StatusColeta.pendente),
        _coleta('p2', StatusColeta.pendente),
        _coleta('s1', StatusColeta.sincronizado),
      ];

      final vm = ColetasViewModel(FakeColetaRepository(coletas));
      vm.coletas.value = coletas;

      expect(vm.pendentes, hasLength(2));
      expect(
        vm.pendentes.every((c) => c.syncStatus == StatusColeta.pendente),
        isTrue,
      );

      vm.dispose();
    });

    test(
      'sync bem-sucedido: coleta representada por StatusColeta.sincronizado',
      () {
        final coleta = _coleta('ok', StatusColeta.sincronizado);

        expect(
          coleta.syncStatus,
          StatusColeta.sincronizado,
          reason:
              'Após sync o syncStatus deve ser sincronizado, '
              'sem campo booleano redundante',
        );
      },
    );
  });
}
