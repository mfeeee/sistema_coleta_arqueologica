import '../datasources/notificacao_api_datasource.dart';
import '../models/notificacao_model.dart';

abstract interface class NotificacaoRepository {
  Future<List<NotificacaoModel>> listar();
  Future<void> marcarComoLida(String id);
  Future<PreferenciasNotificacaoModel> getPreferencias();
  Future<void> atualizarPreferencias(PreferenciasNotificacaoModel preferencias);
}

class NotificacaoRepositoryImpl implements NotificacaoRepository {
  const NotificacaoRepositoryImpl(this._datasource);

  final NotificacaoApiDatasource _datasource;

  @override
  Future<List<NotificacaoModel>> listar() => _datasource.listar();

  @override
  Future<void> marcarComoLida(String id) => _datasource.marcarComoLida(id);

  @override
  Future<PreferenciasNotificacaoModel> getPreferencias() =>
      _datasource.getPreferencias();

  @override
  Future<void> atualizarPreferencias(
    PreferenciasNotificacaoModel preferencias,
  ) => _datasource.atualizarPreferencias(preferencias);
}
