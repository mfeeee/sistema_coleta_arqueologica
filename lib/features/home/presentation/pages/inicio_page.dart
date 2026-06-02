import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/activity_summary_section.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/recent_activities_section.dart';

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
              ActivitySummarySection(
                totalColetas: _viewModel.totalColetas,
                coletasPendentes: _viewModel.coletasPendentes,
              ),
              const SizedBox(height: 32.0),
              RecentActivitiesSection(
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
              context.l10n.homePendingBanner(quantidade),
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
    final l10n = context.l10n;

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
                    l10n.homeGreeting(
                      nome.isNotEmpty ? nome : l10n.homeResearcher,
                    ),
                    style: theme.textTheme.displayLarge?.copyWith(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  l10n.homeSubtitle,
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
    final l10n = context.l10n;

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
                  l10n.homeNewCollection,
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
                  label: l10n.homeViewCollections,
                  onTap: () => context.go('/coletas'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SquareActionCard(
                  icon: Icons.sync,
                  label: l10n.homeSyncNow,
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
