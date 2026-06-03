import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/features/auth/data/password_reset_repository.dart';
import 'password_reset_state.dart';

class PasswordResetNotifier extends ChangeNotifier {
  PasswordResetNotifier({required PasswordResetRepository repositorio})
    : _repositorio = repositorio;

  final PasswordResetRepository _repositorio;

  PasswordResetState _estado = const PasswordResetInitial();
  PasswordResetState get estado => _estado;

  bool get carregando => _estado is PasswordResetLoading;

  Future<void> solicitarReset(String email) async {
    _estado = const PasswordResetLoading();
    notifyListeners();

    final resultado = await _repositorio.requestReset(email);

    switch (resultado) {
      case RequestResetSucesso():
        _estado = const PasswordResetEmailSent();
      case RequestResetFalha(:final mensagem):
        _estado = PasswordResetError(mensagem);
        log(
          'Solicitação de reset falhou: $mensagem',
          name: 'PasswordResetNotifier',
        );
    }

    notifyListeners();
  }

  Future<void> confirmarReset(
    String email,
    String token,
    String novaSenha,
  ) async {
    _estado = const PasswordResetLoading();
    notifyListeners();

    final resultado = await _repositorio.confirmReset(email, token, novaSenha);

    switch (resultado) {
      case ConfirmResetSucesso():
        _estado = const PasswordResetSuccess();
      case ConfirmResetFalha(:final mensagem):
        _estado = PasswordResetError(mensagem);
        log(
          'Confirmação de reset falhou: $mensagem',
          name: 'PasswordResetNotifier',
        );
    }

    notifyListeners();
  }
}
