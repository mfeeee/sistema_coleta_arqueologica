import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../../core/services/conectividade_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../data/sync_repository.dart';

enum SyncState { idle, sincronizando, concluido, semToken, semConexao, erro }

class SyncNotifier extends ChangeNotifier {
  final SyncRepository _repository;
  final SecureStorageService _secureStorage;
  final ConectividadeService _conectividadeService;

  SyncNotifier({
    required SyncRepository repository,
    required SecureStorageService secureStorage,
    required ConectividadeService conectividadeService,
  }) : _repository = repository,
       _secureStorage = secureStorage,
       _conectividadeService = conectividadeService;

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

    final online = await _conectividadeService.verificar();
    if (!online) {
      _state = SyncState.semConexao;
      _mensagemErro = 'Sem conexão. Conecte-se à internet para sincronizar.';
      notifyListeners();
      return;
    }

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
