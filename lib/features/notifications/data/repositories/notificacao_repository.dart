import '../datasources/notificacao_api_datasource.dart';
import '../models/notificacao_model.dart';

abstract interface class NotificacaoRepository {
  Future<List<NotificacaoModel>> buscarNotificacoes();
  Future<void> marcarComoLida(int id);
}

class NotificacaoRepositoryImpl implements NotificacaoRepository {
  const NotificacaoRepositoryImpl(this._datasource);

  final NotificacaoApiDatasource _datasource;

  @override
  Future<List<NotificacaoModel>> buscarNotificacoes() =>
      _datasource.buscarNotificacoes();

  @override
  Future<void> marcarComoLida(int id) => _datasource.marcarComoLida(id);
}
