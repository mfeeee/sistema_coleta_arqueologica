import '../entities/bem_material_entity.dart';

abstract class BemMaterialRepository {
  Future<List<BemMaterialEntity>> getAll();
  Future<List<BemMaterialEntity>> getByColetaId(String coletaId);
  Future<BemMaterialEntity?> getById(String uuid);
  Future<void> salvar(BemMaterialEntity bemMaterial);
  Future<void> deletar(String uuid);
}
