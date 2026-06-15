import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import '../../data/models/notificacao_model.dart';
import '../../domain/notificacoes_viewmodel.dart';

class PreferenciasNotificacoesPage extends StatefulWidget {
  const PreferenciasNotificacoesPage({super.key});

  @override
  State<PreferenciasNotificacoesPage> createState() =>
      _PreferenciasNotificacoesPageState();
}

class _PreferenciasNotificacoesPageState
    extends State<PreferenciasNotificacoesPage> {
  late final NotificacoesViewModel _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final scope = AppScope.of(context);
      _viewModel = NotificacoesViewModel(
        repository: scope.notificacaoRepository,
      );
      _viewModel.carregarPreferencias();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferências de Notificações')),
      body: ValueListenableBuilder<PreferenciasNotificacaoModel?>(
        valueListenable: _viewModel.preferencias,
        builder: (context, prefs, _) {
          if (prefs == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SecaoTitulo(titulo: 'Canais'),
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receber alertas no celular'),
                value: prefs.pushEnabled,
                onChanged: (value) => _viewModel.atualizarPreferencias(
                  prefs.copyWith(pushEnabled: value),
                ),
              ),
              SwitchListTile(
                title: const Text('E-mail'),
                subtitle: const Text('Receber resumos por e-mail'),
                value: prefs.emailEnabled,
                onChanged: (value) => _viewModel.atualizarPreferencias(
                  prefs.copyWith(emailEnabled: value),
                ),
              ),
              const Divider(height: 32),
              const _SecaoTitulo(titulo: 'Tipos de Notificação'),
              _TipoToggle(
                titulo: 'Coletas Aprovadas',
                tipo: 'coleta_aprovada',
                prefs: prefs,
                onChanged: (value) =>
                    _toggleTipo(prefs, 'coleta_aprovada', value),
              ),
              _TipoToggle(
                titulo: 'Coletas Rejeitadas',
                tipo: 'coleta_rejeitada',
                prefs: prefs,
                onChanged: (value) =>
                    _toggleTipo(prefs, 'coleta_rejeitada', value),
              ),
              _TipoToggle(
                titulo: 'Novos Comentários',
                tipo: 'novo_comentario',
                prefs: prefs,
                onChanged: (value) =>
                    _toggleTipo(prefs, 'novo_comentario', value),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleTipo(
    PreferenciasNotificacaoModel prefs,
    String tipo,
    bool habilitado,
  ) {
    final novosTipos = List<String>.from(prefs.tiposHabilitados);
    if (habilitado) {
      if (!novosTipos.contains(tipo)) novosTipos.add(tipo);
    } else {
      novosTipos.remove(tipo);
    }
    _viewModel.atualizarPreferencias(
      prefs.copyWith(tiposHabilitados: novosTipos),
    );
  }
}

class _SecaoTitulo extends StatelessWidget {
  const _SecaoTitulo({required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        titulo,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TipoToggle extends StatelessWidget {
  const _TipoToggle({
    required this.titulo,
    required this.tipo,
    required this.prefs,
    required this.onChanged,
  });

  final String titulo;
  final String tipo;
  final PreferenciasNotificacaoModel prefs;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(titulo),
      value: prefs.tiposHabilitados.contains(tipo),
      onChanged: (value) => onChanged(value ?? false),
    );
  }
}
