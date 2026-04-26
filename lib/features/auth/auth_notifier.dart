import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../core/services/auth_service.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthNotifier extends ChangeNotifier {
  AuthNotifier({required this.authService});

  final AuthService authService;

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await authService.login(email, password);

    switch (result) {
      case AuthSuccess():
        _status = AuthStatus.authenticated;
      case AuthFailure(:final message):
        _status = AuthStatus.error;
        _errorMessage = message;
        log('Login falhou: $message', name: 'AuthNotifier');
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await authService.logout();
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }
}
