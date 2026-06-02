import 'dart:developer';

import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import '../../domain/entities/bem_material_entity.dart';
import '../../domain/repositories/bem_material_repository.dart';
import '../datasources/bem_material_api_datasource.dart';
import '../datasources/bem_material_local_datasource.dart';
import '../models/bem_material_model.dart';

class BemMaterialRepositoryImpl implements BemMaterialRepository {
  final BemMaterialLocalDatasource _localDatasource;
  final BemMaterialApiDatasource _apiDatasource;
  final SecureStorageService _secureStorage;

  const BemMaterialRepositoryImpl({
    required BemMaterialLocalDatasource local,
    required BemMaterialApiDatasource api,
    required SecureStorageService secureStorage,
  }) : _localDatasource = local,
       _apiDatasource = api,
       _secureStorage = secureStorage;

  @override
  Future<List<BemMaterialEntity>> getAll() => _localDatasource.getAll();

  @override
  Future<List<BemMaterialEntity>> getByColetaId(String coletaId) =>
      _localDatasource.getByColetaId(coletaId);

  @override
  Future<BemMaterialEntity?> getById(String uuid) =>
      _localDatasource.getById(uuid);

  @override
  Future<void> salvar(BemMaterialEntity bemMaterial) =>
      _localDatasource.inserir(BemMaterialModel.fromEntity(bemMaterial));

  @override
  Future<void> deletar(String uuid) => _localDatasource.deletar(uuid);

  @override
  Future<int> sincronizarBens() async {
    final publicados = await _localDatasource.countPublicados();
    final ultimoSync = await _secureStorage.getUltimoSyncBens();
    final agora = DateTime.now();
    final deveSync =
        publicados == 0 ||
        ultimoSync == null ||
        agora.difference(ultimoSync).inDays > 30;

    if (!deveSync) {
      log(
        'Bens já sincronizados recentemente ($publicados publicados) — ignorando',
        name: 'BemMaterialRepository',
      );
      return 0;
    }

    int importados = 0;
    int pagina = 1;
    while (true) {
      final bens = await _apiDatasource.fetchBens(page: pagina);
      if (bens.isEmpty) break;
      for (final bem in bens) {
        await _localDatasource.inserir(BemMaterialModel.fromEntity(bem));
      }
      importados += bens.length;
      pagina++;
    }

    if (importados > 0) {
      await _secureStorage.setUltimoSyncBens(agora);
    }
    log('Bens sincronizados: $importados', name: 'BemMaterialRepository');
    return importados;
  }
}
