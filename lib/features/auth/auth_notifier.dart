import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sistema_coleta_arqueologica/core/utils/tratador_de_erros.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/background_sync_service.dart';
import 'domain/usecases/executar_sync_pos_login_use_case.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

enum RecuperacaoStatus { idle, carregando, sucesso, erro }

class AuthNotifier extends ChangeNotifier {
  AuthNotifier({
    required this.authService,
    required ExecutarSyncPosLoginUseCase executarSyncPosLogin,
  }) : _executarSyncPosLogin = executarSyncPosLogin;

  final AuthService authService;
  final ExecutarSyncPosLoginUseCase _executarSyncPosLogin;

  /// Incrementado quando sincronizarBens() termina (com ou sem erros).
  final ValueNotifier<int> contadorSyncBens = ValueNotifier(0);

  /// Incrementado quando sincronizarPull() termina com sucesso.
  final ValueNotifier<int> contadorSyncColetas = ValueNotifier(0);

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  String? _userName;
  String? _userId;
  String? _userEmail;
  String? _userClassificacao;
  String? _userAvatarUrl;
  String? _avisoSistema;

  RecuperacaoStatus _recuperacaoStatus = RecuperacaoStatus.idle;
  String? _recuperacaoErro;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get userName => _userName;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userClassificacao => _userClassificacao;
  String? get userAvatarUrl => _userAvatarUrl;
  String? get avisoSistema => _avisoSistema;
  bool get isLoading => _status == AuthStatus.loading;

  RecuperacaoStatus get recuperacaoStatus => _recuperacaoStatus;
  String? get recuperacaoErro => _recuperacaoErro;
  bool get recuperacaoCarregando =>
      _recuperacaoStatus == RecuperacaoStatus.carregando;

  void limparAviso() {
    _avisoSistema = null;
  }

  void atualizarDadosPerfil({
    String? nome,
    String? email,
    String? avatarUrl,
    bool removerAvatar = false,
  }) {
    if (nome != null) _userName = nome;
    if (email != null) _userEmail = email;
    if (removerAvatar) {
      _userAvatarUrl = null;
    } else if (avatarUrl != null) {
      _userAvatarUrl = avatarUrl;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await authService.login(email, password);

    switch (result) {
      case AuthSuccess(
        userName: final nomeRetornado,
        userId: final idRetornado,
        email: final emailRetornado,
        classificacao: final classifRetornada,
        avatarUrl: final avatarRetornado,
      ):
        _status = AuthStatus.authenticated;
        _userName = nomeRetornado;
        _userId = idRetornado;
        _userEmail = emailRetornado;
        _userClassificacao = classifRetornada;
        _userAvatarUrl = avatarRetornado;
        _executarSyncPosLogin
            .call(idRetornado)
            .catchError(
              (Object e, StackTrace st) => log(
                'Sync pós-login falhou',
                error: e,
                stackTrace: st,
                name: 'AuthNotifier',
              ),
            );
      case AuthFailure(:final message):
        _status = AuthStatus.error;
        _errorMessage = message;
        log('Login falhou: $message', name: 'AuthNotifier');
    }

    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String classificacao,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await authService.register(
      name: name,
      email: email,
      password: password,
      classificacao: classificacao,
    );

    switch (result) {
      case AuthSuccess(
        userName: final nomeRetornado,
        email: final emailRetornado,
        classificacao: final classifRetornada,
      ):
        _status = AuthStatus.authenticated;
        _userName = nomeRetornado;
        _userEmail = emailRetornado;
        _userClassificacao = classifRetornada;
        _userAvatarUrl = null;
        BackgroundSyncService.agendar().then(
          (_) {},
          onError: (Object e, StackTrace st) => log(
            'Agendamento background falhou',
            error: e,
            stackTrace: st,
            name: 'AuthNotifier',
          ),
        );
      case AuthFailure(:final message):
        _status = AuthStatus.error;
        _errorMessage = message;
        log('Registro falhou: $message', name: 'AuthNotifier');
    }

    notifyListeners();
  }

  Future<void> solicitarRecuperacaoSenha(String email) async {
    _recuperacaoStatus = RecuperacaoStatus.carregando;
    _recuperacaoErro = null;
    notifyListeners();

    final result = await authService.solicitarRecuperacaoSenha(email);

    switch (result) {
      case RecuperacaoSucesso():
        _recuperacaoStatus = RecuperacaoStatus.sucesso;
      case RecuperacaoFalha(:final message):
        _recuperacaoStatus = RecuperacaoStatus.erro;
        _recuperacaoErro = message;
        log('Recuperação de senha falhou: $message', name: 'AuthNotifier');
    }

    notifyListeners();
  }

  void resetarEstadoRecuperacao() {
    _recuperacaoStatus = RecuperacaoStatus.idle;
    _recuperacaoErro = null;
  }

  void setarAviso(String msg) {
    _avisoSistema = msg;
    notifyListeners();
  }

  Future<bool> podeDeslogar() => _executarSyncPosLogin.podeDeslogar();

  Future<void> logout() async {
    await authService.logout();
    // INTENCIONAL: SharedPreferences não é limpo no logout.
    // Rascunhos de coleta (chave 'rascunho_coleta') devem sobreviver
    // à sessão para serem restaurados no próximo login.
    BackgroundSyncService.cancelar().then(
      (_) {},
      onError: (Object e, StackTrace st) => log(
        'Cancelamento background falhou',
        error: e,
        stackTrace: st,
        name: 'AuthNotifier',
      ),
    );
    _status = AuthStatus.unauthenticated;
    _userName = null;
    _userId = null;
    _userEmail = null;
    _userClassificacao = null;
    _userAvatarUrl = null;
    _errorMessage = null;
    _avisoSistema = null;
    notifyListeners();
  }

  Future<void> sairPorSessaoExpirada() async {
    await authService.logout();
    // INTENCIONAL: SharedPreferences não é limpo no logout por sessão expirada.
    // Rascunhos de coleta (chave 'rascunho_coleta') devem sobreviver
    // à sessão para serem restaurados no próximo login.
    BackgroundSyncService.cancelar().then(
      (_) {},
      onError: (Object e, StackTrace st) => log(
        'Cancelamento background falhou',
        error: e,
        stackTrace: st,
        name: 'AuthNotifier',
      ),
    );
    _status = AuthStatus.unauthenticated;
    _userName = null;
    _userId = null;
    _userEmail = null;
    _userClassificacao = null;
    _userAvatarUrl = null;
    _errorMessage = TratadorDeErros.sessaoExpirada;
    _avisoSistema = null;
    notifyListeners();
  }

  @override
  void dispose() {
    contadorSyncBens.dispose();
    contadorSyncColetas.dispose();
    super.dispose();
  }
}
