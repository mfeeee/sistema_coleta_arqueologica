import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../data/models/notificacao_model.dart';
import '../data/repositories/notificacao_repository.dart';

class NotificacoesViewModel {
  NotificacoesViewModel({required NotificacaoRepository repository})
    : _repository = repository;

  final NotificacaoRepository _repository;

  final ValueNotifier<bool> carregando = ValueNotifier(false);
  final ValueNotifier<String?> erro = ValueNotifier(null);
  final ValueNotifier<List<NotificacaoModel>> notificacoes = ValueNotifier([]);
  final ValueNotifier<String?> filtroAtivo = ValueNotifier(null);

  List<NotificacaoModel> get filtradas {
    final filtro = filtroAtivo.value;
    if (filtro == null) return notificacoes.value;
    return notificacoes.value.where((n) => n.tipo == filtro).toList();
  }

  int get totalNaoLidas => notificacoes.value.where((n) => !n.lida).length;

  Future<void> carregar() async {
    if (carregando.value) return;
    carregando.value = true;
    erro.value = null;
    try {
      notificacoes.value = await _repository.buscarNotificacoes();
    } catch (e, st) {
      log(
        'Erro ao carregar notificações',
        error: e,
        stackTrace: st,
        name: 'NotificacoesViewModel',
      );
      erro.value = 'Não foi possível carregar as notificações.';
    } finally {
      carregando.value = false;
    }
  }

  void definirFiltro(String? tipo) {
    filtroAtivo.value = tipo;
  }

  Future<void> marcarComoLida(int id) async {
    try {
      await _repository.marcarComoLida(id);
      notificacoes.value = notificacoes.value
          .map((n) => n.id == id ? n.marcarComoLida() : n)
          .toList();
    } catch (e, st) {
      log(
        'Erro ao marcar notificação como lida',
        error: e,
        stackTrace: st,
        name: 'NotificacoesViewModel',
      );
    }
  }

  void dispose() {
    carregando.dispose();
    erro.dispose();
    notificacoes.dispose();
    filtroAtivo.dispose();
  }
}
