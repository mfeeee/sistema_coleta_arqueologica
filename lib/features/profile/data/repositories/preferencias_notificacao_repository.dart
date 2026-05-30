import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/preferencias_api_datasource.dart';
import '../models/preferencias_notificacao.dart';

abstract interface class PreferenciasNotificacaoRepository {
  Future<void> salvar(PreferenciasNotificacao prefs);
  Future<PreferenciasNotificacao> carregar();
}

class PreferenciasNotificacaoRepositoryImpl
    implements PreferenciasNotificacaoRepository {
  const PreferenciasNotificacaoRepositoryImpl(
    this._prefs, {
    this.apiDatasource,
  });

  final SharedPreferences _prefs;
  final PreferenciasApiDatasource? apiDatasource;

  static const _chave = 'preferencias_notificacao_json';

  @override
  Future<void> salvar(PreferenciasNotificacao prefs) async {
    await _prefs.setString(_chave, jsonEncode(prefs.toJson()));
    final api = apiDatasource;
    if (api != null) {
      api.salvar(prefs).catchError((Object e) {
        log(
          'Falha ao sincronizar preferências com o backend: $e',
          name: 'PreferenciasNotificacaoRepository',
        );
      });
    }
  }

  @override
  Future<PreferenciasNotificacao> carregar() async {
    final api = apiDatasource;
    if (api != null) {
      try {
        final remoto = await api.buscar();
        await _prefs.setString(_chave, jsonEncode(remoto.toJson()));
        return remoto;
      } catch (e) {
        log(
          'Falha ao buscar preferências do backend, usando cache local: $e',
          name: 'PreferenciasNotificacaoRepository',
        );
      }
    }
    final json = _prefs.getString(_chave);
    if (json == null) return const PreferenciasNotificacao();
    return PreferenciasNotificacao.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }
}
