import 'dart:developer';
import '../repositories/coleta_repository.dart';
import '../../data/datasources/coleta_api_datasource.dart';

class PullService {
  PullService({required this.apiDatasource, required this.localRepository});

  final ColetaApiDatasource apiDatasource;
  final ColetaRepository localRepository;

  Future<void> sincronizarPull() async {
    int page = 1;
    int importadas = 0;

    while (true) {
      final remotas = await apiDatasource.fetchMinhas(page: page);
      if (remotas.isEmpty) break;

      for (final remota in remotas) {
        final local = await localRepository.getById(remota.id);

        if (local == null) {
          await localRepository.salvar(remota);
          importadas++;
        } else if (remota.versao > local.versao) {
          await localRepository.salvar(remota);
          importadas++;
        }
      }

      if (remotas.length < 20) break;
      page++;
    }

    log(
      'Pull concluído: $importadas coleta(s) importada(s)',
      name: 'PullService',
    );
  }
}
