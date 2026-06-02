import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/core/l10n/app_localizations.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';

class RecentActivitiesSection extends StatelessWidget {
  const RecentActivitiesSection({super.key, required this.coletasRecentes});

  final ValueNotifier<List<ColetaEntity>> coletasRecentes;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                l10n.homeRecentActivities,
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
                  l10n.homeViewAll,
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
              if (coletas.isEmpty) return const _EmptyActivities();
              return Column(
                children: <Widget>[
                  for (var i = 0; i < coletas.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _ActivityListItem(
                      icon: Icons.location_on_outlined,
                      title: coletas[i].nomeBem.isNotEmpty
                          ? coletas[i].nomeBem
                          : l10n.homeNoTitle,
                      subtitle: _formatarData(coletas[i].dataColeta, l10n),
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
            context.l10n.homeNoCollections,
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

String _formatarData(DateTime data, AppLocalizations l10n) {
  final agora = DateTime.now();
  final hoje = DateTime(agora.year, agora.month, agora.day);
  final ontem = hoje.subtract(const Duration(days: 1));
  final diaColeta = DateTime(data.year, data.month, data.day);
  final hora =
      '${data.hour.toString().padLeft(2, '0')}:'
      '${data.minute.toString().padLeft(2, '0')}';

  if (diaColeta == hoje) return l10n.homeTodayAt(hora);
  if (diaColeta == ontem) return l10n.homeYesterdayAt(hora);
  return '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/'
      '${data.year}';
}
