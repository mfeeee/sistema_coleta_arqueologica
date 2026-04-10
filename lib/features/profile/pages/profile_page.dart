import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            icon: Icon(Icons.settings_outlined, color: theme.colorScheme.primary, size: 24),
            onPressed: () {
              // TODO
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
          child: Column(
            children: const <Widget>[
              _UserInfoSection(),
              SizedBox(height: 32.0),
              _MetricsSection(),
              SizedBox(height: 32.0),
              _NotificationSection(),
              SizedBox(height: 32.0),
              _AppPreferencesSection(),
              SizedBox(height: 32.0),
              _ActionButtonsSection(),
            ],
          ),
        ),
      ),
    );
  }
}


class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Nome e E-mail
          Text(
            'Dr. Julian Martínez',
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 24,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'julian.martinez@archaeo.app',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: const Text(
              'ARQUEÓLOGO',
              style: TextStyle(
                color: Colors.white,
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
  const _MetricsSection();

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

          Row(
            children: <Widget>[
              Expanded(
                child: _MetricCard(
                  title: 'SÍTIOS MAPEADOS',
                  value: '42',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricCard(
                  title: 'DIAS EM CAMPO',
                  value: '156',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection();

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
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Alertas de Sincronização',
                  trailing: Switch(
                    value: true,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (bool val) {},
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.fact_check_outlined,
                  title: 'Status de Curadoria',
                  trailing: Switch(
                    value: false,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (bool val) {},
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Avisos de Proximidade',
                  trailing: Switch(
                    value: true,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (bool val) {},
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

class _AppPreferencesSection extends StatelessWidget {
  const _AppPreferencesSection();

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
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Modo Escuro',
                  trailing: Switch(
                    value: false,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (bool val) {},
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.straighten_outlined,
                  title: 'Unidades de Medida',
                  trailing: Text(
                    'Métrico',
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                ),
                const Divider(height: 1, indent: 48),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Idioma',
                  trailing: Text(
                    'Português',
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
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
  const _ActionButtonsSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          // Botão Exportar Logs 
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // TODO
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.bug_report_outlined, color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Exportar logs de erro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Botão Sair da Conta
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onSurface,
              elevation: 0,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.go('/login');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.logout, color: theme.colorScheme.errorContainer, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Sair da conta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.errorContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Card de Estatística
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
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
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
  const _SettingsTile({required this.icon, required this.title, required this.trailing});
  final IconData icon;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}