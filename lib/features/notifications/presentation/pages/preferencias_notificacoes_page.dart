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
                value: prefs.push,
                onChanged: (value) => _viewModel.atualizarPreferencias(
                  prefs.copyWith(push: value),
                ),
              ),
              const Divider(height: 32),
              const _SecaoTitulo(titulo: 'Tipos de Notificação'),
              SwitchListTile(
                title: const Text('Coletas'),
                subtitle: const Text('Aprovações e rejeições de coleta'),
                value: prefs.coleta,
                onChanged: (value) => _viewModel.atualizarPreferencias(
                  prefs.copyWith(coleta: value),
                ),
              ),
              SwitchListTile(
                title: const Text('Sincronização'),
                subtitle: const Text('Alertas de sync e conflitos'),
                value: prefs.sync,
                onChanged: (value) => _viewModel.atualizarPreferencias(
                  prefs.copyWith(sync: value),
                ),
              ),
              SwitchListTile(
                title: const Text('Sistema'),
                subtitle: const Text('Avisos gerais do sistema'),
                value: prefs.sistema,
                onChanged: (value) => _viewModel.atualizarPreferencias(
                  prefs.copyWith(sistema: value),
                ),
              ),
            ],
          );
        },
      ),
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
