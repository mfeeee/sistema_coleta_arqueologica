import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/entities/localizacao_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/proximidade_service.dart';
import '../../helpers/fakes/fake_coleta_repository.dart';

// Coordenadas de referência
const _latParnaiba = -2.9078;
const _lonParnaiba = -41.7722;
const _latTeresina = -5.0892;
const _lonTeresina = -42.8019;

ColetaEntity _criarSitio({
  required String id,
  required double lat,
  required double lon,
}) => ColetaEntity(
  id: id,
  usuarioId: 'u1',
  nomeBem: 'Sítio $id',
  localizacao: LocalizacaoEntity(id: 'loc-$id', lat: lat, lng: lon),
  dataColeta: DateTime(2024),
  updatedAt: DateTime(2024),
  versao: 1,
  syncStatus: StatusColeta.pendente,
  artefatoTipos: const [],
  dadosColetados: {},
);

void main() {
  group('ProximidadeService.calcularDistanciaMetros', () {
    test('pontos idênticos retornam distância zero', () {
      final distancia = ProximidadeService.calcularDistanciaMetros(
        _latParnaiba,
        _lonParnaiba,
        _latParnaiba,
        _lonParnaiba,
      );

      expect(distancia, closeTo(0.0, 0.001));
    });

    test('Parnaíba → Teresina retorna ~270 km', () {
      final distancia = ProximidadeService.calcularDistanciaMetros(
        _latParnaiba,
        _lonParnaiba,
        _latTeresina,
        _lonTeresina,
      );

      // Distância reta entre as cidades: ~268 km; tolerância de ±30 km.
      expect(distancia, closeTo(268000, 30000));
    });
  });

  group('ProximidadeService.buscarBemMaterialsProximos', () {
    test('sítio a ~111 m (dentro do raio 500 m) é detectado', () async {
      // 0.001° de latitude ≈ 111 m
      final sitio = _criarSitio(
        id: 'dentro',
        lat: _latParnaiba + 0.001,
        lon: _lonParnaiba,
      );
      final service = ProximidadeService(FakeColetaRepository([sitio]));

      final proximos = await service.buscarBemMaterialsProximos(
        latAtual: _latParnaiba,
        lonAtual: _lonParnaiba,
      );

      expect(proximos, hasLength(1));
      expect(proximos.first.id, 'dentro');
    });

    test('sítio a ~667 m (fora do raio 500 m) não é detectado', () async {
      // 0.006° de latitude ≈ 667 m
      final sitio = _criarSitio(
        id: 'fora',
        lat: _latParnaiba + 0.006,
        lon: _lonParnaiba,
      );
      final service = ProximidadeService(FakeColetaRepository([sitio]));

      final proximos = await service.buscarBemMaterialsProximos(
        latAtual: _latParnaiba,
        lonAtual: _lonParnaiba,
      );

      expect(proximos, isEmpty);
    });

    test('nenhum sítio cadastrado retorna lista vazia', () async {
      final service = ProximidadeService(FakeColetaRepository());

      final proximos = await service.buscarBemMaterialsProximos(
        latAtual: _latParnaiba,
        lonAtual: _lonParnaiba,
      );

      expect(proximos, isEmpty);
    });

    test('raio personalizado de 1000 m detecta sítio a ~667 m', () async {
      final sitio = _criarSitio(
        id: 'no-raio',
        lat: _latParnaiba + 0.006,
        lon: _lonParnaiba,
      );
      final service = ProximidadeService(FakeColetaRepository([sitio]));

      final proximos = await service.buscarBemMaterialsProximos(
        latAtual: _latParnaiba,
        lonAtual: _lonParnaiba,
        raioMetros: 1000,
      );

      expect(proximos, hasLength(1));
    });
  });
}
