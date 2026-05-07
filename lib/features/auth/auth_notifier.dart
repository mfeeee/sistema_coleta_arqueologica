import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/pull_service.dart';
import '../../core/services/auth_service.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthNotifier extends ChangeNotifier {
  AuthNotifier({
    required this.authService,
    required ColetaRepository coletaRepository,
    required PullService pullService,
  }) : _coletaRepository = coletaRepository,
       _pullService = pullService;

  final AuthService authService;
  final ColetaRepository _coletaRepository;
  final PullService _pullService;

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  String? _userName;
  String? _userId;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get userName => _userName;
  String? get userId => _userId;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await authService.login(email, password);

    switch (result) {
      case AuthSuccess():
        _status = AuthStatus.authenticated;
        _userName = result.userName;
        _userId = result.userId;
        _pullService.sincronizarPull().catchError(
          (e) => log('Pull falhou silenciosamente: $e', name: 'AuthNotifier'),
        );
      case AuthFailure(:final message):
        _status = AuthStatus.error;
        _errorMessage = message;
        log('Login falhou: $message', name: 'AuthNotifier');
    }

    notifyListeners();
  }

  Future<bool> podeDeslogar() async {
    final pendentes = await _coletaRepository.getPendentes();
    return pendentes.isEmpty;
  }

  Future<void> logout() async {
    await authService.logout();
    _status = AuthStatus.unauthenticated;
    _userName = null;
    _userId = userId;
    _errorMessage = null;
    notifyListeners();
  }
}
