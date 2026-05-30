import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import '../../data/models/preferencias_notificacao.dart';
import '../../data/repositories/preferencias_notificacao_repository.dart';

class PreferenciasNotificacaoPage extends StatefulWidget {
  const PreferenciasNotificacaoPage({super.key});

  @override
  State<PreferenciasNotificacaoPage> createState() =>
      _PreferenciasNotificacaoPageState();
}

class _PreferenciasNotificacaoPageState
    extends State<PreferenciasNotificacaoPage> {
  late final PreferenciasNotificacaoRepository _repository;
  late final ValueNotifier<PreferenciasNotificacao> _preferencias;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _repository = AppScope.of(context).preferenciasRepository;
      _preferencias = ValueNotifier(const PreferenciasNotificacao());
      _carregar();
    }
  }

  Future<void> _carregar() async {
    try {
      final prefs = await _repository.carregar();
      _preferencias.value = prefs;
    } catch (e, st) {
      log(
        'Erro ao carregar preferências',
        error: e,
        stackTrace: st,
        name: 'PreferenciasNotificacaoPage',
      );
    }
  }

  Future<void> _atualizar(PreferenciasNotificacao novas) async {
    _preferencias.value = novas;
    try {
      await _repository.salvar(novas);
    } catch (e, st) {
      log(
        'Erro ao salvar preferências',
        error: e,
        stackTrace: st,
        name: 'PreferenciasNotificacaoPage',
      );
    }
  }

  @override
  void dispose() {
    _preferencias.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(
          'Preferências de Notificação',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
      ),
      body: ValueListenableBuilder<PreferenciasNotificacao>(
        valueListenable: _preferencias,
        builder: (context, prefs, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            children: <Widget>[
              _GrupoPreferencias(
                titulo: 'Tipos de Notificação',
                tiles: <Widget>[
                  _PreferenciaTile(
                    icone: Icons.archive_outlined,
                    titulo: 'Notificações de Coleta',
                    subtitulo:
                        'Aprovações, rejeições e atualizações de coletas',
                    valor: prefs.habilitarColeta,
                    aoAlterar: (v) =>
                        _atualizar(prefs.copyWith(habilitarColeta: v)),
                  ),
                  const Divider(height: 1, indent: 56),
                  _PreferenciaTile(
                    icone: Icons.sync_outlined,
                    titulo: 'Notificações de Sincronização',
                    subtitulo: 'Alertas sobre status e falhas de sincronização',
                    valor: prefs.habilitarSync,
                    aoAlterar: (v) =>
                        _atualizar(prefs.copyWith(habilitarSync: v)),
                  ),
                  const Divider(height: 1, indent: 56),
                  _PreferenciaTile(
                    icone: Icons.info_outline,
                    titulo: 'Notificações do Sistema',
                    subtitulo: 'Avisos gerais e atualizações do aplicativo',
                    valor: prefs.habilitarSistema,
                    aoAlterar: (v) =>
                        _atualizar(prefs.copyWith(habilitarSistema: v)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _GrupoPreferencias(
                titulo: 'Canal de Entrega',
                tiles: <Widget>[
                  _PreferenciaTile(
                    icone: Icons.notifications_outlined,
                    titulo: 'Notificações Push',
                    subtitulo:
                        'Receber alertas mesmo com o aplicativo em segundo plano',
                    valor: prefs.habilitarNotificacoesPush,
                    aoAlterar: (v) => _atualizar(
                      prefs.copyWith(habilitarNotificacoesPush: v),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GrupoPreferencias extends StatelessWidget {
  const _GrupoPreferencias({required this.titulo, required this.tiles});

  final String titulo;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titulo,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }
}

class _PreferenciaTile extends StatelessWidget {
  const _PreferenciaTile({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    required this.aoAlterar,
  });

  final IconData icone;
  final String titulo;
  final String subtitulo;
  final bool valor;
  final ValueChanged<bool> aoAlterar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$titulo: ${valor ? 'habilitado' : 'desabilitado'}',
      child: SwitchListTile(
        secondary: Icon(icone, color: theme.colorScheme.primary, size: 22),
        title: Text(
          titulo,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitulo,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        value: valor,
        activeThumbColor: theme.colorScheme.primary,
        onChanged: aoAlterar,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
      ),
    );
  }
}
