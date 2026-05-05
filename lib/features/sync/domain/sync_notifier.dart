import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../../core/services/secure_storage_service.dart';
import '../data/sync_repository.dart';

enum SyncState { idle, sincronizando, concluido, semToken, erro }

class SyncNotifier extends ChangeNotifier {
  final SyncRepository _repository;
  final SecureStorageService _secureStorage;

  SyncNotifier({
    required SyncRepository repository,
    required SecureStorageService secureStorage,
  }) : _repository = repository,
       _secureStorage = secureStorage;

  SyncState _state = SyncState.idle;
  SyncResumo? _ultimoResumo;
  String? _mensagemErro;
  int _pendentes = 0;

  SyncState get state => _state;
  SyncResumo? get ultimoResumo => _ultimoResumo;
  String? get mensagemErro => _mensagemErro;
  int get pendentes => _pendentes;
  bool get sincronizando => _state == SyncState.sincronizando;

  Future<void> carregarPendentes() async {
    _pendentes = await _repository.contarPendentes();
    notifyListeners();
  }

  Future<void> sincronizar() async {
    if (_state == SyncState.sincronizando) return;

    final token = await _secureStorage.getJwt();
    if (token == null) {
      _state = SyncState.semToken;
      _mensagemErro = 'Sessão expirada. Faça login novamente.';
      notifyListeners();
      return;
    }

    _state = SyncState.sincronizando;
    _mensagemErro = null;
    _ultimoResumo = null;
    notifyListeners();

    try {
      final resumo = await _repository.sincronizarTodas(token);
      _ultimoResumo = resumo;
      _pendentes = await _repository.contarPendentes();
      _state = SyncState.concluido;
    } catch (e, st) {
      log(
        'Erro inesperado no SyncNotifier',
        error: e,
        stackTrace: st,
        name: 'SyncNotifier',
      );
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      _state = SyncState.erro;
    }

    notifyListeners();
  }
}
