import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferencias_notificacao.dart';

abstract interface class PreferenciasNotificacaoRepository {
  Future<void> salvar(PreferenciasNotificacao prefs);
  Future<PreferenciasNotificacao> carregar();
}

class PreferenciasNotificacaoRepositoryImpl
    implements PreferenciasNotificacaoRepository {
  const PreferenciasNotificacaoRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _chave = 'preferencias_notificacao_json';

  @override
  Future<void> salvar(PreferenciasNotificacao prefs) async {
    await _prefs.setString(_chave, jsonEncode(prefs.toJson()));
  }

  @override
  Future<PreferenciasNotificacao> carregar() async {
    final json = _prefs.getString(_chave);
    if (json == null) return const PreferenciasNotificacao();
    return PreferenciasNotificacao.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }
}
