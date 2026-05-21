import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/sync/data/sync_api_datasource.dart';

class FakeSyncApiDatasource implements SyncApiDatasource {
  FakeSyncApiDatasource({this.status = SyncResultStatus.sucesso});

  final SyncResultStatus status;

  @override
  Future<SyncResultado> enviarColeta({
    required ColetaEntity coleta,
    required String bearerToken,
    Map<String, dynamic>? dadosColetadosOverride,
    void Function(int tentativa, int max)? onTentativa,
  }) async => SyncResultado(coletaId: coleta.id, status: status);
}
