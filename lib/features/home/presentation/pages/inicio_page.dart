import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/viewmodels/home_viewmodel.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late final HomeViewModel _viewModel;
  late final AuthNotifier _authNotifier;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final scope = AppScope.of(context);
      _authNotifier = scope.authNotifier;
      _viewModel = HomeViewModel(
        coletaRepository: scope.coletaRepository,
        authNotifier: scope.authNotifier,
      );
      _viewModel.carregarDados();
      _authNotifier.addListener(_onAuthAlterado);
    }
  }

  void _onAuthAlterado() {
    if (_authNotifier.status == AuthStatus.authenticated) {
      _viewModel.carregarDados();
    }
  }

  @override
  void dispose() {
    _authNotifier.removeListener(_onAuthAlterado);
    _viewModel.dispose();
    super.dispose();
  }

  void _irParaNovaColeta() async {
    await context.push('/nova-coleta');
    if (mounted) _viewModel.carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 16.0,
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ArqueoData',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 18,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              onPressed: () => context.push('/notificacoes'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _WelcomeSection(nomeUsuario: _viewModel.nomeUsuario),
              ValueListenableBuilder<int>(
                valueListenable: _viewModel.coletasPendentes,
                builder: (context, qtd, _) {
                  if (qtd == 0) return const SizedBox.shrink();
                  return _BannerPendentes(quantidade: qtd);
                },
              ),
              const SizedBox(height: 32.0),
              _QuickActionsSection(onNovaColeta: _irParaNovaColeta),
              const SizedBox(height: 32.0),
              _ActivitySummarySection(
                totalColetas: _viewModel.totalColetas,
                coletasPendentes: _viewModel.coletasPendentes,
              ),
              const SizedBox(height: 32.0),
              _RecentActivitiesSection(
                coletasRecentes: _viewModel.coletasRecentes,
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerPendentes extends StatelessWidget {
  const _BannerPendentes({required this.quantidade});

  final int quantidade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.sync_problem_outlined,
            color: theme.colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$quantidade coleta${quantidade > 1 ? 's' : ''} '
              'aguardando envio',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({required this.nomeUsuario});

  final ValueNotifier<String> nomeUsuario;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 2.0,
              ),
            ),
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.person, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ValueListenableBuilder<String>(
                  valueListenable: nomeUsuario,
                  builder: (context, nome, _) => Text(
                    'Olá, ${nome.isNotEmpty ? nome : 'Pesquisador'}',
                    style: theme.textTheme.displayLarge?.copyWith(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Pronto para novas descobertas hoje?',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection({required this.onNovaColeta});

  final VoidCallback onNovaColeta;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: onNovaColeta,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 72),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add_circle_outline,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Nova Coleta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _SquareActionCard(
                  icon: Icons.folder_open_outlined,
                  label: 'Ver Minhas Coletas',
                  onTap: () => context.go('/coletas'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SquareActionCard(
                  icon: Icons.sync,
                  label: 'Sincronizar Agora',
                  onTap: () => context.go('/sincronizar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SquareActionCard extends StatelessWidget {
  const _SquareActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 98,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: theme.colorScheme.onPrimaryContainer, size: 24),
              const SizedBox(height: 8.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: theme.colorScheme.onPrimaryContainer,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivitySummarySection extends StatelessWidget {
  const _ActivitySummarySection({
    required this.totalColetas,
    required this.coletasPendentes,
  });

  final ValueNotifier<int> totalColetas;
  final ValueNotifier<int> coletasPendentes;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Resumo das Atividades',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: Listenable.merge([totalColetas, coletasPendentes]),
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${totalColetas.value}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'TOTAL',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${coletasPendentes.value}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'PENDENTES',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RecentActivitiesSection extends StatelessWidget {
  const _RecentActivitiesSection({required this.coletasRecentes});

  final ValueNotifier<List<ColetaEntity>> coletasRecentes;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Atividades Recentes',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.7,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/coletas'),
                child: Text(
                  'Ver tudo',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<List<ColetaEntity>>(
            valueListenable: coletasRecentes,
            builder: (context, coletas, _) {
              if (coletas.isEmpty) {
                return const _EmptyActivities();
              }
              return Column(
                children: <Widget>[
                  for (var i = 0; i < coletas.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _ActivityListItem(
                      icon: Icons.location_on_outlined,
                      title: coletas[i].nomeBem.isNotEmpty
                          ? coletas[i].nomeBem
                          : 'Coleta sem título',
                      subtitle: _formatarData(coletas[i].dataColeta),
                      onTap: () => context.push(
                        '/detalhes-coleta',
                        extra: coletas[i].id,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyActivities extends StatelessWidget {
  const _EmptyActivities();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhuma coleta registrada ainda.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityListItem extends StatelessWidget {
  const _ActivityListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimaryContainer.withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatarData(DateTime data) {
  final agora = DateTime.now();
  final hoje = DateTime(agora.year, agora.month, agora.day);
  final ontem = hoje.subtract(const Duration(days: 1));
  final diaColeta = DateTime(data.year, data.month, data.day);
  final hora =
      '${data.hour.toString().padLeft(2, '0')}:'
      '${data.minute.toString().padLeft(2, '0')}';

  if (diaColeta == hoje) return 'Hoje, às $hora';
  if (diaColeta == ontem) return 'Ontem, às $hora';
  return '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year}';
}
