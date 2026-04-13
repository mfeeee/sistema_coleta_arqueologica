// ignore_for_file: unused_import, unused_element, unused_local_variable, unused_field

import '../entities/sitio_cache_entity.dart';

/// TODO: Defina as assinaturas (contratos) das funções que vão interagir com os dados.
abstract class ColetaRepository {
  Future<List<SitioCacheEntity>> getSitiosCacheOffline();

  // TODO: Adicionar futuramente o método de salvarNovaColeta(...)
}
