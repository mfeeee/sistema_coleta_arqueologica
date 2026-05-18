import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/status_coleta.dart';
import 'package:sistema_coleta_arqueologica/core/utils/log_capture.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/repositories/coleta_repository.dart';

class ProfileViewModel {
  ProfileViewModel({
    required AuthNotifier authNotifier,
    required ColetaRepository coletaRepository,
    required SharedPreferences prefs,
    required ValueNotifier<ThemeMode> temaModo,
  }) : _authNotifier = authNotifier,
       _coletaRepository = coletaRepository,
       _prefs = prefs,
       _temaModoApp = temaModo {
    _inicializar();
  }

  final AuthNotifier _authNotifier;
  final ColetaRepository _coletaRepository;
  final SharedPreferences _prefs;
  final ValueNotifier<ThemeMode> _temaModoApp;

  static const _keyAlertasSincronizacao = 'pref_alertas_sincronizacao';
  static const _keyStatusCuradoria = 'pref_status_curadoria';
  static const _keyAvisosProximidade = 'pref_avisos_proximidade';
  static const _keyModoEscuro = 'pref_modo_escuro';

  late final ValueNotifier<bool> alertasSincronizacao;
  late final ValueNotifier<bool> statusCuradoria;
  late final ValueNotifier<bool> avisosProximidade;
  late final ValueNotifier<bool> modoEscuro;

  final ValueNotifier<bool> estaCarregando = ValueNotifier(false);
  final ValueNotifier<bool> exportandoLogs = ValueNotifier(false);
  final ValueNotifier<bool> temPendentesSemSync = ValueNotifier(false);
  final ValueNotifier<int> totalColetas = ValueNotifier(0);
  final ValueNotifier<int> coletasPendentes = ValueNotifier(0);

  String get nome => _authNotifier.userName ?? 'Usuário';
  String get email => _authNotifier.userEmail ?? '';
  String get classificacao => _authNotifier.userClassificacao ?? '';
  String get iniciais => _extrairIniciais(nome);

  void _inicializar() {
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
    totalColetas.value = await _coletaRepository.contarTodas();
    coletasPendentes.value = await _coletaRepository.contarPorStatus(
      StatusColeta.pendente,
    );
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
  }
}
