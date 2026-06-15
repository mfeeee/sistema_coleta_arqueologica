import 'dart:async';
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
  final ValueNotifier<PreferenciasNotificacaoModel?> preferencias =
      ValueNotifier(null);

  int get totalNaoLidas => notificacoes.value.where((n) => !n.lida).length;

  Future<void> carregar() async {
    if (carregando.value) return;
    carregando.value = true;
    erro.value = null;
    try {
      notificacoes.value = await _repository.listar();
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

  Future<void> carregarPreferencias() async {
    try {
      preferencias.value = await _repository.getPreferencias();
    } catch (e, st) {
      log(
        'Erro ao carregar preferências de notificação',
        error: e,
        stackTrace: st,
        name: 'NotificacoesViewModel',
      );
    }
  }

  Future<void> atualizarPreferencias(
    PreferenciasNotificacaoModel novasPreferencias,
  ) async {
    try {
      await _repository.atualizarPreferencias(novasPreferencias);
      preferencias.value = novasPreferencias;
    } catch (e, st) {
      log(
        'Erro ao atualizar preferências de notificação',
        error: e,
        stackTrace: st,
        name: 'NotificacoesViewModel',
      );
    }
  }

  Future<void> marcarComoLida(String id) async {
    try {
      await _repository.marcarComoLida(id);
      notificacoes.value = notificacoes.value.map((n) {
        if (n.id == id) {
          return n.copyWith(lida: true, lidaEm: DateTime.now());
        }
        return n;
      }).toList();
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
    preferencias.dispose();
  }
}
