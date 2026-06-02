import '../entities/bem_material_entity.dart';

abstract class BemMaterialRepository {
  Future<List<BemMaterialEntity>> getAll();
  Future<List<BemMaterialEntity>> getByColetaId(String coletaId);
  Future<BemMaterialEntity?> getById(String uuid);
  Future<void> salvar(BemMaterialEntity bemMaterial);
  Future<void> deletar(String uuid);

  /// Busca todas as páginas da API e persiste localmente.
  /// Só executa se o banco estiver vazio ou o último sync tiver >30 dias.
  /// Retorna o total de bens importados (0 se o sync foi ignorado).
  Future<int> sincronizarBens({bool forcar = false});
}
