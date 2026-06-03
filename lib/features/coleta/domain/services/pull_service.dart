import 'dart:developer';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';
import '../repositories/coleta_repository.dart';
import '../../data/datasources/coleta_api_datasource.dart';

class PullService {
  PullService({
    required this.apiDatasource,
    required this.localRepository,
    required this.secureStorage,
  });

  final ColetaApiDatasource apiDatasource;
  final ColetaRepository localRepository;
  final SecureStorageService secureStorage;

  Future<int> sincronizarPull(String usuarioId) async {
    int page = 1;
    int importadas = 0;
    int totalRemoto = 0;

    while (true) {
      final resultado = await apiDatasource.fetchMinhas(page: page);
      totalRemoto = resultado.total;

      for (final remota in resultado.items) {
        if (remota.usuarioId != usuarioId) continue;

        final local = await localRepository.getById(remota.id);
        if (local == null || remota.versao > local.versao) {
          await localRepository.salvar(remota);
          importadas++;
        }
      }

      if (!resultado.temProxima) break;
      page++;
    }

    await secureStorage.setTotalColetasRemoto(totalRemoto);
    log(
      'Pull: $importadas importadas | total remoto: $totalRemoto',
      name: 'PullService',
    );
    return totalRemoto;
  }
}
