import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import '../../data/models/notificacao_model.dart';
import '../../domain/notificacoes_viewmodel.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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
      _viewModel.carregar();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/notificacoes/preferencias'),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _viewModel.carregando,
          _viewModel.erro,
          _viewModel.notificacoes,
        ]),
        builder: (context, _) {
          if (_viewModel.carregando.value &&
              _viewModel.notificacoes.value.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final mensagemErro = _viewModel.erro.value;
          if (mensagemErro != null && _viewModel.notificacoes.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(mensagemErro),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _viewModel.carregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final itens = _viewModel.notificacoes.value;

          if (itens.isEmpty) {
            return const Center(
              child: Text('Nenhuma notificação por enquanto.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _viewModel.carregar,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final notificacao = itens[index];
                return _TileNotificacao(
                  notificacao: notificacao,
                  aoTocar: () => _viewModel.marcarComoLida(notificacao.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TileNotificacao extends StatelessWidget {
  const _TileNotificacao({required this.notificacao, required this.aoTocar});

  final NotificacaoModel notificacao;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: notificacao.lida ? 0 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: notificacao.lida ? cs.surfaceContainerLow : cs.surface,
      child: ListTile(
        onTap: aoTocar,
        leading: CircleAvatar(
          backgroundColor: _corPorTipo(notificacao.tipo, cs),
          child: Icon(_iconePorTipo(notificacao.tipo), color: Colors.white),
        ),
        title: Text(
          notificacao.titulo,
          style: TextStyle(
            fontWeight: notificacao.lida ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notificacao.corpo),
            const SizedBox(height: 4),
            Text(
              _formatarData(notificacao.createdAt),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        trailing: !notificacao.lida
            ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  IconData _iconePorTipo(String tipo) {
    return switch (tipo) {
      'coleta_aprovada' => Icons.check_circle_outline,
      'coleta_rejeitada' => Icons.error_outline,
      'novo_comentario' => Icons.comment_outlined,
      _ => Icons.notifications_none,
    };
  }

  Color _corPorTipo(String tipo, ColorScheme cs) {
    return switch (tipo) {
      'coleta_aprovada' => Colors.green,
      'coleta_rejeitada' => Colors.red,
      'novo_comentario' => Colors.blue,
      _ => cs.primary,
    };
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year} ${data.hour}:${data.minute.toString().padLeft(2, '0')}';
  }
}
