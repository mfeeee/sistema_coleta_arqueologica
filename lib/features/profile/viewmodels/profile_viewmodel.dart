import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/services/profile_service.dart';
import 'package:sistema_coleta_arqueologica/core/utils/log_capture.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';

class ProfileViewModel {
  ProfileViewModel({
    required AuthNotifier authNotifier,
    required ProfileService profileService,
    required ColetaRepository coletaRepository,
    required SharedPreferences prefs,
    required ValueNotifier<ThemeMode> temaModo,
    required ValueNotifier<Locale> idiomaAtual,
    required ValueNotifier<String?> fotoPerfilPath,
  }) : _authNotifier = authNotifier,
       _profileService = profileService,
       _coletaRepository = coletaRepository,
       _prefs = prefs,
       _temaModoApp = temaModo,
       _idiomaApp = idiomaAtual,
       _fotoPerfilPath = fotoPerfilPath {
    _inicializar();
  }

  final AuthNotifier _authNotifier;
  final ProfileService _profileService;
  final ColetaRepository _coletaRepository;
  final SharedPreferences _prefs;
  final ValueNotifier<ThemeMode> _temaModoApp;
  final ValueNotifier<Locale> _idiomaApp;
  final ValueNotifier<String?> _fotoPerfilPath;

  static const _keyAlertasSincronizacao = 'pref_alertas_sincronizacao';
  static const _keyStatusCuradoria = 'pref_status_curadoria';
  static const _keyAvisosProximidade = 'pref_avisos_proximidade';
  static const _keyModoEscuro = 'pref_modo_escuro';
  static const _keyIdioma = 'pref_idioma';

  late final ValueNotifier<String> nomeAtual;
  late final ValueNotifier<String> emailAtual;
  late final ValueNotifier<String> classificacaoAtual;
  late final ValueNotifier<String?> avatarUrl;

  ValueNotifier<Locale> get idiomaAtual => _idiomaApp;

  final ValueNotifier<bool> salvandoDados = ValueNotifier(false);
  final ValueNotifier<bool> excluindoConta = ValueNotifier(false);
  final ValueNotifier<bool> fotoCarregando = ValueNotifier(false);
  final ValueNotifier<String?> erroSalvamento = ValueNotifier(null);

  late final ValueNotifier<bool> alertasSincronizacao;
  late final ValueNotifier<bool> statusCuradoria;
  late final ValueNotifier<bool> avisosProximidade;
  late final ValueNotifier<bool> modoEscuro;

  final ValueNotifier<bool> estaCarregando = ValueNotifier(false);
  final ValueNotifier<bool> exportandoLogs = ValueNotifier(false);
  final ValueNotifier<bool> temPendentesSemSync = ValueNotifier(false);
  final ValueNotifier<int> totalColetas = ValueNotifier(0);
  final ValueNotifier<int> coletasPendentes = ValueNotifier(0);
  final ValueNotifier<String?> erroAtual = ValueNotifier(null);

  String get nome => nomeAtual.value;
  String get email => emailAtual.value;
  String get classificacao => classificacaoAtual.value;
  String get iniciais => _extrairIniciais(nomeAtual.value);

  void _inicializar() {
    nomeAtual = ValueNotifier(_authNotifier.userName ?? 'Usuário');
    emailAtual = ValueNotifier(_authNotifier.userEmail ?? '');
    classificacaoAtual = ValueNotifier(
      _authNotifier.userClassificacao ?? 'estudante',
    );
    avatarUrl = ValueNotifier(_authNotifier.userAvatarUrl);
    _fotoPerfilPath.value = _authNotifier.userAvatarUrl;

    final modoEscuroSalvo =
        _prefs.getBool(_keyModoEscuro) ??
        (_temaModoApp.value == ThemeMode.dark);

    alertasSincronizacao = ValueNotifier(
      _prefs.getBool(_keyAlertasSincronizacao) ?? true,
    );
    statusCuradoria = ValueNotifier(
      _prefs.getBool(_keyStatusCuradoria) ?? false,
    );
    avisosProximidade = ValueNotifier(
      _prefs.getBool(_keyAvisosProximidade) ?? true,
    );
    modoEscuro = ValueNotifier(modoEscuroSalvo);

    alertasSincronizacao.addListener(_salvarAlertasSincronizacao);
    statusCuradoria.addListener(_salvarStatusCuradoria);
    avisosProximidade.addListener(_salvarAvisosProximidade);
    modoEscuro.addListener(_aoAlterarModoEscuro);
  }

  Future<void> carregarEstatisticas() async {
    erroAtual.value = null;
    try {
      totalColetas.value = await _coletaRepository.contarTodas();
      coletasPendentes.value = await _coletaRepository.contarPorStatus(
        StatusColeta.pendente,
      );
    } catch (e, st) {
      log(
        'Erro ao carregar estatísticas do perfil',
        error: e,
        stackTrace: st,
        name: 'ProfileViewModel',
      );
      erroAtual.value = 'Não foi possível carregar as estatísticas.';
    }
  }

  Future<bool> atualizarFoto(File arquivo) async {
    fotoCarregando.value = true;
    erroSalvamento.value = null;
    try {
      final result = await _profileService.uploadAvatar(arquivo);
      switch (result) {
        case ProfileSuccess(:final data):
          final url = data['avatar_url'] as String?;
          avatarUrl.value = url;
          _fotoPerfilPath.value = url;
          _authNotifier.atualizarDadosPerfil(avatarUrl: url);
          return true;
        case ProfileFailure(:final message):
          erroSalvamento.value = message;
          return false;
      }
    } catch (e, st) {
      log(
        'Erro ao enviar foto',
        error: e,
        stackTrace: st,
        name: 'ProfileViewModel',
      );
      erroSalvamento.value = 'Não foi possível enviar a foto.';
      return false;
    } finally {
      fotoCarregando.value = false;
    }
  }

  Future<bool> removerFoto() async {
    fotoCarregando.value = true;
    erroSalvamento.value = null;
    try {
      final result = await _profileService.deleteAvatar();
      switch (result) {
        case ProfileSuccess():
          avatarUrl.value = null;
          _fotoPerfilPath.value = null;
          _authNotifier.atualizarDadosPerfil(removerAvatar: true);
          return true;
        case ProfileFailure(:final message):
          erroSalvamento.value = message;
          return false;
      }
    } catch (e, st) {
      log(
        'Erro ao remover foto',
        error: e,
        stackTrace: st,
        name: 'ProfileViewModel',
      );
      erroSalvamento.value = 'Não foi possível remover a foto.';
      return false;
    } finally {
      fotoCarregando.value = false;
    }
  }

  Future<bool> salvarDadosPessoais({
    required String nome,
    required String email,
    required String classificacao,
  }) async {
    salvandoDados.value = true;
    erroSalvamento.value = null;
    try {
      final result = await _profileService.updateProfile(
        name: nome,
        email: email,
        classificacao: classificacao,
      );
      switch (result) {
        case ProfileSuccess(:final data):
          nomeAtual.value = data['name'] as String? ?? nome;
          emailAtual.value = data['email'] as String? ?? email;
          classificacaoAtual.value = classificacao;
          _authNotifier.atualizarDadosPerfil(
            nome: nomeAtual.value,
            email: emailAtual.value,
          );
          return true;
        case ProfileFailure(:final message):
          erroSalvamento.value = message;
          return false;
      }
    } catch (e, st) {
      log(
        'Erro ao salvar dados pessoais',
        error: e,
        stackTrace: st,
        name: 'ProfileViewModel',
      );
      erroSalvamento.value = 'Não foi possível salvar as alterações.';
      return false;
    } finally {
      salvandoDados.value = false;
    }
  }

  Future<bool> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    salvandoDados.value = true;
    erroSalvamento.value = null;
    try {
      final result = await _profileService.updateProfile(
        password: novaSenha,
        passwordConfirmation: novaSenha,
      );
      switch (result) {
        case ProfileSuccess():
          return true;
        case ProfileFailure(:final message):
          erroSalvamento.value = message;
          return false;
      }
    } catch (e, st) {
      log(
        'Erro ao alterar senha',
        error: e,
        stackTrace: st,
        name: 'ProfileViewModel',
      );
      erroSalvamento.value = 'Não foi possível alterar a senha.';
      return false;
    } finally {
      salvandoDados.value = false;
    }
  }

  void _salvarAlertasSincronizacao() =>
      _prefs.setBool(_keyAlertasSincronizacao, alertasSincronizacao.value);

  void _salvarStatusCuradoria() =>
      _prefs.setBool(_keyStatusCuradoria, statusCuradoria.value);

  void _salvarAvisosProximidade() =>
      _prefs.setBool(_keyAvisosProximidade, avisosProximidade.value);

  void _aoAlterarModoEscuro() {
    final novo = modoEscuro.value ? ThemeMode.dark : ThemeMode.light;
    _temaModoApp.value = novo;
    _prefs.setBool(_keyModoEscuro, modoEscuro.value);
  }

  void alternarIdioma() {
    final novoIdioma = _idiomaApp.value.languageCode == 'pt'
        ? const Locale('en', 'US')
        : const Locale('pt', 'BR');
    _idiomaApp.value = novoIdioma;
    _prefs.setString(
      _keyIdioma,
      '${novoIdioma.languageCode}_${novoIdioma.countryCode}',
    );
  }

  Future<void> sair() async {
    final pode = await _authNotifier.podeDeslogar();
    if (!pode) {
      temPendentesSemSync.value = true;
      return;
    }
    estaCarregando.value = true;
    await _authNotifier.logout();
    estaCarregando.value = false;
  }

  Future<bool> excluirConta() async {
    excluindoConta.value = true;
    erroSalvamento.value = null;
    try {
      final result = await _profileService.deleteAccount();
      switch (result) {
        case ProfileSuccess():
          await _authNotifier.logout();
          return true;
        case ProfileFailure(:final message):
          erroSalvamento.value = message;
          return false;
      }
    } catch (e, st) {
      log(
        'Erro ao excluir conta',
        error: e,
        stackTrace: st,
        name: 'ProfileViewModel',
      );
      erroSalvamento.value = 'Não foi possível excluir a conta.';
      return false;
    } finally {
      excluindoConta.value = false;
    }
  }

  Future<void> exportarLogs() async {
    if (kIsWeb) return;
    exportandoLogs.value = true;
    try {
      final dir = await getTemporaryDirectory();
      final arquivo = File('${dir.path}/arqueodata_logs.txt');
      await arquivo.writeAsString(_gerarConteudoLog());
      await Share.shareXFiles([
        XFile(arquivo.path),
      ], subject: 'Logs ArqueoData');
    } catch (e, stack) {
      log(
        'Erro ao exportar logs',
        error: e,
        stackTrace: stack,
        name: 'ProfileViewModel',
      );
    } finally {
      exportandoLogs.value = false;
    }
  }

  String _gerarConteudoLog() {
    final buffer = StringBuffer();
    final agora = DateTime.now();
    buffer.writeln('=== ArqueoData - Log de Diagnóstico ===');
    buffer.writeln('Exportado em: ${agora.toIso8601String()}');
    buffer.writeln('Versão: 1.0.0');
    buffer.writeln('Plataforma: ${_nomePlataforma()}');
    buffer.writeln('');
    buffer.writeln('--- Usuário ---');
    buffer.writeln('Nome: $nome');
    buffer.writeln('E-mail: $email');
    buffer.writeln('Perfil: $classificacao');
    buffer.writeln('');
    buffer.writeln('--- Registros ---');
    final entradas = LogCapture.obterEntradas();
    if (entradas.isEmpty) {
      buffer.writeln('Nenhum registro capturado nesta sessão.');
    } else {
      entradas.forEach(buffer.writeln);
    }
    return buffer.toString();
  }

  String _nomePlataforma() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    return 'Desconhecida';
  }

  String _extrairIniciais(String nomeCompleto) {
    if (nomeCompleto.isEmpty) return '?';
    final partes = nomeCompleto.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }

  void dispose() {
    nomeAtual.dispose();
    emailAtual.dispose();
    classificacaoAtual.dispose();
    avatarUrl.dispose();
    salvandoDados.dispose();
    excluindoConta.dispose();
    fotoCarregando.dispose();
    erroSalvamento.dispose();
    alertasSincronizacao
      ..removeListener(_salvarAlertasSincronizacao)
      ..dispose();
    statusCuradoria
      ..removeListener(_salvarStatusCuradoria)
      ..dispose();
    avisosProximidade
      ..removeListener(_salvarAvisosProximidade)
      ..dispose();
    modoEscuro
      ..removeListener(_aoAlterarModoEscuro)
      ..dispose();
    estaCarregando.dispose();
    exportandoLogs.dispose();
    temPendentesSemSync.dispose();
    totalColetas.dispose();
    coletasPendentes.dispose();
    erroAtual.dispose();
  }
}
