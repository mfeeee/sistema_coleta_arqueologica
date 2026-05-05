import '../../domain/entities/bem_material_entity.dart';
import '../../domain/repositories/bem_material_repository.dart';
import '../datasources/bem_material_local_datasource.dart';
import '../models/bem_material_model.dart';

class BemMaterialRepositoryImpl implements BemMaterialRepository {
  final BemMaterialLocalDatasource _datasource;

  const BemMaterialRepositoryImpl(this._datasource);

  @override
  Future<List<BemMaterialEntity>> getAll() => _datasource.getAll();

  @override
  Future<List<BemMaterialEntity>> getByColetaId(String coletaId) =>
      _datasource.getByColetaId(coletaId);

  @override
  Future<BemMaterialEntity?> getById(String uuid) => _datasource.getById(uuid);

  @override
  Future<void> salvar(BemMaterialEntity bemMaterial) {
    return _datasource.inserir(BemMaterialModel.fromEntity(bemMaterial));
  }

  @override
  Future<void> deletar(String uuid) => _datasource.deletar(uuid);
}
