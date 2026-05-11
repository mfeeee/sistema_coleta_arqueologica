import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/utils/geolocator_helper.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/proximidade_service.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/presentation/viewmodels/coleta_viewmodel.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeGeolocatorHelper extends GeolocatorHelper {
  final Future<Coordenada> Function() _resultado;

  _FakeGeolocatorHelper(this._resultado);

  @override
  Future<Coordenada> obterCoordenadaAtual() => _resultado();
}

class _FakeColetaRepository implements ColetaRepository {
  final List<ColetaEntity> _coletas;

  _FakeColetaRepository([this._coletas = const []]);

  @override
  Future<List<ColetaEntity>> getAll() async => _coletas;
  @override
  Future<List<ColetaEntity>> getPendentes() async => [];
  @override
  Future<ColetaEntity?> getById(String uuid) async => null;
  @override
  Future<void> salvar(ColetaEntity coleta) async {}
  @override
  Future<void> atualizarStatus(
    String uuid,
    dynamic status,
    int novaVersao,
  ) async {}
  @override
  Future<void> deletar(String uuid) async {}
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

_FakeGeolocatorHelper _gpsComCoordenada(double lat, double lon) =>
    _FakeGeolocatorHelper(() async => (latitude: lat, longitude: lon));

_FakeGeolocatorHelper _gpsLancando(Exception excecao) =>
    _FakeGeolocatorHelper(() async => throw excecao);

ColetaViewModel _criarViewModel({
  required GeolocatorHelper geolocator,
  List<ColetaEntity> sitiosProximos = const [],
}) {
  final repositorio = _FakeColetaRepository(sitiosProximos);
  final proximidade = ProximidadeService(repositorio);
  return ColetaViewModel(
    proximidadeService: proximidade,
    geolocatorHelper: geolocator,
  );
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('ColetaViewModel.iniciarMapeamento', () {
    test('sucesso: step vai para fillingForm e coordenada é salva', () async {
      final vm = _criarViewModel(
        geolocator: _gpsComCoordenada(-8.8475, -42.5480),
      );

      await vm.iniciarMapeamento();

      expect(vm.stepNotifier.value, ColetaStep.fillingForm);
      expect(vm.coordenadaAtual?.latitude, closeTo(-8.8475, 0.0001));
      expect(vm.coordenadaAtual?.longitude, closeTo(-42.5480, 0.0001));
      expect(vm.errorMessage.value, isNull);

      vm.dispose();
    });

    test('sítios próximos: step vai para proximityAlert', () async {
      final sitio = ColetaEntity(
        id: 'site-1',
        nomeBem: 'Sítio Teste',
        latitude: -8.8475,
        longitude: -42.5480,
        dataColeta: DateTime.now(),
        updatedAt: DateTime.now(),
        versao: 1,
        usuarioId: 'u1',
        artefatos: [],
        syncStatus: StatusColeta.pendente,
        dadosColetados: {},
      );

      final vm = _criarViewModel(
        geolocator: _gpsComCoordenada(-8.8475, -42.5480),
        sitiosProximos: [sitio],
      );

      await vm.iniciarMapeamento();

      expect(vm.stepNotifier.value, ColetaStep.proximityAlert);
      expect(vm.sitiosConflitantes, hasLength(1));

      vm.dispose();
    });

    test('permissão negada: step vai para permissaoNegada', () async {
      final vm = _criarViewModel(
        geolocator: _gpsLancando(const PermissaoNegadaException()),
      );

      await vm.iniciarMapeamento();

      expect(vm.stepNotifier.value, ColetaStep.permissaoNegada);
      expect(vm.errorMessage.value, isNotNull);
      expect(vm.errorMessage.value, isNotEmpty);

      vm.dispose();
    });

    test('permissão negada permanentemente: step vai para '
        'permissaoNegadaPermanentemente', () async {
      final vm = _criarViewModel(
        geolocator: _gpsLancando(
          const PermissaoNegadaPermanentementeException(),
        ),
      );

      await vm.iniciarMapeamento();

      expect(vm.stepNotifier.value, ColetaStep.permissaoNegadaPermanentemente);
      expect(vm.errorMessage.value, isNotNull);

      vm.dispose();
    });

    test('GPS desativado: step vai para gpsDesativado', () async {
      final vm = _criarViewModel(
        geolocator: _gpsLancando(const ServicoGpsDesativadoException()),
      );

      await vm.iniciarMapeamento();

      expect(vm.stepNotifier.value, ColetaStep.gpsDesativado);
      expect(vm.errorMessage.value, isNotNull);

      vm.dispose();
    });

    test('timeout: step vai para error com mensagem de timeout', () async {
      final vm = _criarViewModel(
        geolocator: _gpsLancando(TimeoutException('timeout')),
      );

      await vm.iniciarMapeamento();

      expect(vm.stepNotifier.value, ColetaStep.error);
      expect(vm.errorMessage.value, TratadorDeErros.timeout);

      vm.dispose();
    });

    test('tentarNovamente após erro: reinicia o mapeamento', () async {
      var chamadas = 0;
      final geolocator = _FakeGeolocatorHelper(() async {
        chamadas++;
        if (chamadas == 1) throw const PermissaoNegadaException();
        return (latitude: -8.8, longitude: -42.5);
      });

      final vm = _criarViewModel(geolocator: geolocator);

      await vm.iniciarMapeamento();
      expect(vm.stepNotifier.value, ColetaStep.permissaoNegada);

      await vm.iniciarMapeamento();
      expect(vm.stepNotifier.value, ColetaStep.fillingForm);
      expect(chamadas, 2);

      vm.dispose();
    });

    test('erro limpa mensagem anterior antes de nova tentativa', () async {
      var tentativa = 0;
      final geolocator = _FakeGeolocatorHelper(() async {
        tentativa++;
        if (tentativa == 1) throw const PermissaoNegadaException();
        return (latitude: -8.8, longitude: -42.5);
      });

      final vm = _criarViewModel(geolocator: geolocator);

      await vm.iniciarMapeamento();
      expect(vm.errorMessage.value, isNotNull);

      await vm.iniciarMapeamento();
      expect(vm.errorMessage.value, isNull);

      vm.dispose();
    });
  });

  group('ColetaViewModel.prosseguirParaFormularioIgnorandoAlerta', () {
    test('muda step de proximityAlert para fillingForm', () async {
      final sitio = ColetaEntity(
        id: 'site-1',
        nomeBem: 'Sítio Teste',
        latitude: -8.8475,
        longitude: -42.5480,
        dataColeta: DateTime.now(),
        updatedAt: DateTime.now(),
        versao: 1,
        usuarioId: 'u1',
        artefatos: [],
        syncStatus: StatusColeta.pendente,
        dadosColetados: {},
      );

      final vm = _criarViewModel(
        geolocator: _gpsComCoordenada(-8.8475, -42.5480),
        sitiosProximos: [sitio],
      );

      await vm.iniciarMapeamento();
      expect(vm.stepNotifier.value, ColetaStep.proximityAlert);

      vm.prosseguirParaFormularioIgnorandoAlerta();
      expect(vm.stepNotifier.value, ColetaStep.fillingForm);

      vm.dispose();
    });
  });
}
