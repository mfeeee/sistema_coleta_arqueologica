import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import '../../data/models/notificacao_model.dart';
import '../../domain/notificacoes_viewmodel.dart';

const _kFiltros = <({String? tipo, String rotulo})>[
  (tipo: null, rotulo: 'Todos'),
  (tipo: 'coleta', rotulo: 'Coleta'),
  (tipo: 'sync', rotulo: 'Sync'),
  (tipo: 'sistema', rotulo: 'Sistema'),
];

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
      _viewModel.iniciarPolling();
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
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
        title: Text(
          'Notificações',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _viewModel.carregando,
          _viewModel.erro,
          _viewModel.notificacoes,
          _viewModel.filtroAtivo,
        ]),
        builder: (context, _) {
          if (_viewModel.carregando.value &&
              _viewModel.notificacoes.value.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final mensagemErro = _viewModel.erro.value;
          if (mensagemErro != null && _viewModel.notificacoes.value.isEmpty) {
            return _EstadoErro(
              mensagem: mensagemErro,
              aoTentar: _viewModel.carregar,
            );
          }

          return Column(
            children: <Widget>[
              _BarraFiltros(viewModel: _viewModel),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _viewModel.carregar,
                  child: _ListaNotificacoes(viewModel: _viewModel),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BarraFiltros extends StatelessWidget {
  const _BarraFiltros({required this.viewModel});

  final NotificacoesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtroAtivo = viewModel.filtroAtivo.value;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _kFiltros.map((f) {
            final selecionado = filtroAtivo == f.tipo;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Semantics(
                label: 'Filtrar por ${f.rotulo}',
                selected: selecionado,
                child: FilterChip(
                  label: Text(f.rotulo),
                  selected: selecionado,
                  onSelected: (_) => viewModel.definirFiltro(f.tipo),
                  selectedColor: theme.colorScheme.primaryContainer,
                  checkmarkColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color: selecionado
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: selecionado
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ListaNotificacoes extends StatelessWidget {
  const _ListaNotificacoes({required this.viewModel});

  final NotificacoesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final itens = viewModel.filtradas;

    if (itens.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [SizedBox(height: 120), _EstadoVazio()],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      itemCount: itens.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _TileNotificacao(
        notificacao: itens[index],
        aoTocar: () => viewModel.marcarComoLida(itens[index].id),
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
    final config = _configPorTipo(notificacao.tipo, cs);

    return GestureDetector(
      onTap: aoTocar,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: config.corBorda, width: 4)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _IconeTipo(
                icone: config.icone,
                corFundo: config.corFundo,
                corIcone: config.corIcone,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ConteudoTile(notificacao: notificacao, cs: cs),
              ),
              if (!notificacao.lida) _BadgeNaoLida(cs: cs),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconeTipo extends StatelessWidget {
  const _IconeTipo({
    required this.icone,
    required this.corFundo,
    required this.corIcone,
  });

  final IconData icone;
  final Color corFundo;
  final Color corIcone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icone, color: corIcone, size: 20),
    );
  }
}

class _ConteudoTile extends StatelessWidget {
  const _ConteudoTile({required this.notificacao, required this.cs});

  final NotificacaoModel notificacao;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                notificacao.titulo,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              notificacao.tipo.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: cs.outline,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          notificacao.mensagem,
          style: TextStyle(
            fontSize: 12,
            color: cs.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatarData(notificacao.criadaEm),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: cs.outline.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _BadgeNaoLida extends StatelessWidget {
  const _BadgeNaoLida({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.notifications_none_outlined,
            size: 56,
            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhuma notificação encontrada.',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _EstadoErro extends StatelessWidget {
  const _EstadoErro({required this.mensagem, required this.aoTentar});

  final String mensagem;
  final VoidCallback aoTentar;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: aoTentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

({Color corBorda, Color corFundo, Color corIcone, IconData icone})
_configPorTipo(String tipo, ColorScheme cs) => switch (tipo) {
  'coleta' => (
    corBorda: const Color(0xFF4CAF50),
    corFundo: const Color(0xFFE8F5E9),
    corIcone: const Color(0xFF2E7D32),
    icone: Icons.archive_outlined,
  ),
  'sync' => (
    corBorda: const Color(0xFFFFC107),
    corFundo: const Color(0xFFFFF8E1),
    corIcone: const Color(0xFFF57F17),
    icone: Icons.sync_problem_outlined,
  ),
  'sistema' => (
    corBorda: const Color(0xFF2196F3),
    corFundo: const Color(0xFFE3F2FD),
    corIcone: const Color(0xFF1565C0),
    icone: Icons.info_outline,
  ),
  _ => (
    corBorda: cs.primary.withValues(alpha: 0.4),
    corFundo: cs.primary.withValues(alpha: 0.08),
    corIcone: cs.primary,
    icone: Icons.notifications_outlined,
  ),
};

String _formatarData(DateTime data) {
  final agora = DateTime.now();
  final diff = agora.difference(data);

  if (diff.inMinutes < 60) return 'Há ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'Há ${diff.inHours}h';
  if (diff.inDays == 1) return 'Ontem';
  return 'Há ${diff.inDays} dias';
}
