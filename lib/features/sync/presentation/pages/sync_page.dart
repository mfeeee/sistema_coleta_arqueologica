import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/sync/domain/sync_notifier.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({super.key});

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppScope.of(context).syncNotifier.carregarPendentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final syncNotifier = AppScope.of(context).syncNotifier;
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        titleSpacing: 16.0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
        title: Text(
          l10n.syncPageTitle,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 18,
            letterSpacing: -0.45,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              // TODO: Abrir ajuda ou FAQ sobre sincronização
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: syncNotifier,
        builder: (context, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _NetworkStatusCard(),
                  const SizedBox(height: 16),
                  _SyncProgressCard(notifier: syncNotifier),
                  const SizedBox(height: 24),
                  _DetailedBreakdownSection(notifier: syncNotifier),
                  const SizedBox(height: 32),
                  _ActionSection(notifier: syncNotifier),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NetworkStatusCard extends StatelessWidget {
  const _NetworkStatusCard();

  @override
  Widget build(BuildContext context) {
    final estaOnline = AppScope.of(context).conectividadeService.estaOnline;

    return ValueListenableBuilder<bool>(
      valueListenable: estaOnline,
      builder: (context, online, _) => _ConexaoCard(online: online),
    );
  }
}

class _ConexaoCard extends StatelessWidget {
  const _ConexaoCard({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    final Color iconColor = online
        ? AppColors.success
        : theme.colorScheme.onSurfaceVariant;
    final Color iconBgColor = online
        ? AppColors.successBg
        : theme.colorScheme.surfaceContainerHigh;
    final IconData icone = online ? Icons.wifi : Icons.wifi_off;
    final String rotulo = online ? l10n.syncOnline : l10n.syncOffline;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icone, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.syncConnectionStatus,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  rotulo,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: iconColor,
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

class _SyncProgressCard extends StatelessWidget {
  const _SyncProgressCard({required this.notifier});

  final SyncNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    final resumo = notifier.ultimoResumo;
    final total = resumo?.total ?? 0;
    final sucessos = resumo?.sucessos ?? 0;
    final progresso = total > 0 ? (sucessos / total).clamp(0.0, 1.0) : 0.0;
    final porcentagem = (progresso * 100).toInt();

    final label = resumo != null
        ? l10n.syncPercentLabel(porcentagem)
        : l10n.syncPendingCountLabel(notifier.pendentes);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.syncGeneralProgress,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                resumo != null ? '$porcentagem%' : '--',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progresso),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return Stack(
                children: <Widget>[
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
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

class _DetailedBreakdownSection extends StatelessWidget {
  const _DetailedBreakdownSection({required this.notifier});

  final SyncNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    final resumo = notifier.ultimoResumo;

    const okColor = AppColors.success;
    const okBgColor = AppColors.successBgAlt;
    final pendColor = theme.colorScheme.primary;
    final pendBgColor = theme.colorScheme.primary.withValues(alpha: 0.1);
    final conflictColor = theme.colorScheme.error;
    final conflictBgColor = theme.colorScheme.errorContainer;

    Widget pendentesChip() {
      final count = notifier.pendentes;
      if (count == 0) {
        return _StatusChip(
          text: l10n.syncOk,
          textColor: okColor,
          bgColor: okBgColor,
        );
      }
      return _StatusChip(
        text: l10n.syncPendingCountLabel(count),
        textColor: pendColor,
        bgColor: pendBgColor,
      );
    }

    Widget conflitosChip() {
      final count = resumo?.conflitos ?? 0;
      if (count == 0) {
        return _StatusChip(
          text: l10n.syncOk,
          textColor: okColor,
          bgColor: okBgColor,
        );
      }
      return _StatusChip(
        text: l10n.syncConflictCount(count),
        textColor: conflictColor,
        bgColor: conflictBgColor,
      );
    }

    Widget errosChip() {
      final count = resumo?.erros ?? 0;
      if (count == 0) {
        return _StatusChip(
          text: l10n.syncOk,
          textColor: okColor,
          bgColor: okBgColor,
        );
      }
      return _StatusChip(
        text: l10n.syncErrorCount(count),
        textColor: conflictColor,
        bgColor: conflictBgColor,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            l10n.syncDetails,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
            ),
          ),
        ),
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
              _BreakdownTile(
                icon: Icons.location_on_outlined,
                iconColor: okColor,
                title: l10n.syncGpsData,
                trailingChip: _StatusChip(
                  text: l10n.syncOk,
                  textColor: okColor,
                  bgColor: okBgColor,
                ),
              ),
              const Divider(height: 1, indent: 48),
              _BreakdownTile(
                icon: Icons.description_outlined,
                iconColor: theme.colorScheme.primary,
                title: l10n.syncPendingForms,
                trailingChip: pendentesChip(),
              ),
              const Divider(height: 1, indent: 48),
              _BreakdownTile(
                icon: Icons.warning_amber_outlined,
                iconColor: conflictColor,
                title: l10n.syncConflictsLabel,
                trailingChip: conflitosChip(),
              ),
              const Divider(height: 1, indent: 48),
              _BreakdownTile(
                icon: Icons.cloud_off_outlined,
                iconColor: conflictColor,
                title: l10n.syncSendErrors,
                trailingChip: errosChip(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({required this.notifier});

  final SyncNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;
    final sincronizando = notifier.sincronizando;
    final resumo = notifier.ultimoResumo;

    String feedbackMsg = l10n.syncLastSyncNever;
    Color feedbackColor = theme.colorScheme.onSurfaceVariant;

    switch (notifier.state) {
      case SyncState.concluido:
        if (resumo != null && resumo.totalOk) {
          feedbackMsg = l10n.syncSuccessAll;
          feedbackColor = AppColors.success;
        } else {
          feedbackMsg = l10n.syncNeedsReview(resumo?.conflitos ?? 0);
          feedbackColor = theme.colorScheme.error;
        }
      case SyncState.semToken:
        feedbackMsg = l10n.syncExpiredSession;
        feedbackColor = theme.colorScheme.error;
      case SyncState.semConexao:
        feedbackMsg = notifier.mensagemErro ?? l10n.syncNoConnection;
        feedbackColor = AppColors.warningAlt;
      case SyncState.sincronizando:
        feedbackMsg = notifier.mensagemProgresso ?? l10n.syncInProgress;
        feedbackColor = theme.colorScheme.onSurfaceVariant;
      case SyncState.erro:
        feedbackMsg = notifier.mensagemErro ?? l10n.syncUnexpectedError;
        feedbackColor = theme.colorScheme.error;
      default:
        break;
    }

    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: sincronizando ? null : () => notifier.sincronizar(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          child: sincronizando
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.sync,
                      color: theme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.syncStartButton,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 16),
        Text(
          feedbackMsg,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: feedbackColor,
          ),
        ),
      ],
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailingChip,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget trailingChip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          trailingChip,
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.text,
    required this.textColor,
    required this.bgColor,
  });

  final String text;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
