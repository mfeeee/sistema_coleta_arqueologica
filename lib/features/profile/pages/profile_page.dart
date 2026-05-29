import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/features/profile/viewmodels/profile_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileViewModel _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final scope = AppScope.of(context);
      _viewModel = ProfileViewModel(
        authNotifier: scope.authNotifier,
        coletaRepository: scope.coletaRepository,
        prefs: scope.prefs,
        temaModo: scope.temaModo,
      );
      _viewModel.carregarEstatisticas();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _confirmarLogout() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text(
          'Deseja encerrar a sessão? Coletas não sincronizadas '
          'precisam ser enviadas antes de sair.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    await _viewModel.sair();

    if (!mounted) return;

    if (_viewModel.temPendentesSemSync.value) {
      _viewModel.temPendentesSemSync.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Você tem coletas pendentes de sincronização. '
            'Sincronize antes de sair.',
          ),
        ),
      );
    }
    // GoRouter redireciona automaticamente via refreshListenable após logout.
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        titleSpacing: 16.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
        title: Text(
          'Perfil',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 18,
            height: 1.2,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: () => context.push('/notificacoes'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
          child: Column(
            children: <Widget>[
              _UserInfoSection(viewModel: _viewModel),
              const SizedBox(height: 32.0),
              _MetricsSection(
                totalColetas: _viewModel.totalColetas,
                coletasPendentes: _viewModel.coletasPendentes,
              ),
              const SizedBox(height: 32.0),
              _NotificationSection(viewModel: _viewModel),
              const SizedBox(height: 32.0),
              _AppPreferencesSection(viewModel: _viewModel),
              const SizedBox(height: 32.0),
              _ActionButtonsSection(
                viewModel: _viewModel,
                onLogout: _confirmarLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String badge = viewModel.classificacao.isNotEmpty
        ? viewModel.classificacao.toUpperCase()
        : 'USUÁRIO';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 4.0,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                viewModel.iniciais,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.nome,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 24,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.email,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({
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
            'Estatísticas de Campo',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: Listenable.merge([totalColetas, coletasPendentes]),
            builder: (context, _) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: _MetricCard(
                      title: 'COLETAS REGISTRADAS',
                      value: '${totalColetas.value}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      title: 'PENDENTES SYNC',
                      value: '${coletasPendentes.value}',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Notificações',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.45,
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
            child: Column(
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Alertas de Sincronização',
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: viewModel.alertasSincronizacao,
                    builder: (_, valor, __) => Switch(
                      value: valor,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (v) =>
                          viewModel.alertasSincronizacao.value = v,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.fact_check_outlined,
                  title: 'Status de Curadoria',
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: viewModel.statusCuradoria,
                    builder: (_, valor, __) => Switch(
                      value: valor,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (v) => viewModel.statusCuradoria.value = v,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Avisos de Proximidade',
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: viewModel.avisosProximidade,
                    builder: (_, valor, __) => Switch(
                      value: valor,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (v) => viewModel.avisosProximidade.value = v,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.tune_outlined,
                  title: 'Preferências de Notificação',
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.outline,
                  ),
                  onTap: () => context.push('/perfil/preferencias-notificacao'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppPreferencesSection extends StatelessWidget {
  const _AppPreferencesSection({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Preferências do App',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: -0.45,
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
            child: Column(
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Modo Escuro',
                  trailing: ValueListenableBuilder<bool>(
                    valueListenable: viewModel.modoEscuro,
                    builder: (_, valor, __) => Switch(
                      value: valor,
                      activeThumbColor: theme.colorScheme.primary,
                      onChanged: (v) => viewModel.modoEscuro.value = v,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.straighten_outlined,
                  title: 'Unidades de Medida',
                  trailing: Text(
                    'Métrico',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Idioma',
                  trailing: Text(
                    'Português',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection({
    required this.viewModel,
    required this.onLogout,
  });

  final ProfileViewModel viewModel;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          ValueListenableBuilder<bool>(
            valueListenable: viewModel.exportandoLogs,
            builder: (_, exportando, __) => OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: exportando ? null : viewModel.exportarLogs,
              child: exportando
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.bug_report_outlined,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Exportar logs de erro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<bool>(
            valueListenable: viewModel.estaCarregando,
            builder: (_, carregando, __) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.onSurface,
                elevation: 0,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: carregando ? null : onLogout,
              child: carregando
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.errorContainer,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.logout,
                          color: theme.colorScheme.errorContainer,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sair da conta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.errorContainer,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
