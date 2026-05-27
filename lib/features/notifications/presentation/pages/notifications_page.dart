import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: <Widget>[
          const _NotificationCard(
            borderColor: AppColors.successBright,
            iconBgColor: AppColors.successBg,
            iconColor: AppColors.success,
            icon: Icons.check_circle_outline,
            badgeText: 'SUCESSO',
            title: 'Coleta "Sítio Lapa do Sol" foi aprovada!',
            description:
                'O registro foi validado pela curadoria e já está disponível no catálogo global.',
            timestamp: 'Há 5 min',
          ),
          const SizedBox(height: 12),
          const _NotificationCard(
            borderColor: AppColors.notifYellowBorder,
            iconBgColor: AppColors.notifYellowBg,
            iconColor: AppColors.notifYellowIcon,
            icon: Icons.sync_problem,
            badgeText: 'SISTEMA',
            title: 'Sincronização pendente: 3 registros aguardando conexão.',
            description:
                'Conecte-se ao Wi-Fi para fazer o upload das imagens de alta resolução.',
            timestamp: '2 horas atrás',
          ),
          const SizedBox(height: 12),
          const _NotificationCard(
            borderColor: AppColors.notifOrangeBorder,
            iconBgColor: AppColors.notifOrangeBg,
            iconColor: AppColors.notifOrangeIcon,
            icon: Icons.location_on_outlined,
            badgeText: 'AVISO',
            title:
                'Proximidade detectada: Você está próximo a um sítio já registrado.',
            description:
                'O Sítio "Caverna do Eco" está a menos de 50 metros. Verifique o mapa.',
            timestamp: '5 horas atrás',
          ),
          const SizedBox(height: 12),
          _NotificationCard(
            borderColor: theme.colorScheme.primary.withValues(alpha: 0.4),
            iconBgColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            iconColor: theme.colorScheme.primary,
            icon: Icons.info_outline,
            badgeText: 'INFO',
            title: 'Atualização de Protocolo',
            description:
                'Novas diretrizes para escavação em solo arenoso foram adicionadas ao guia.',
            timestamp: 'Ontem',
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.borderColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.badgeText,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  final Color borderColor;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final String badgeText;
  final String title;
  final String description;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
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
          border: Border(left: BorderSide(color: borderColor, width: 4)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Título e Badge na mesma linha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
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
                        badgeText,
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

                  // Descrição
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Timestamp
                  Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: cs.outline.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
