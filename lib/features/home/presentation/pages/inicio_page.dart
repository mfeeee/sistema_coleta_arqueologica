import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/widgets/custom_header.dart';
import 'package:go_router/go_router.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // TODO
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 24.0, bottom: 144.0),
          child: Column(
            children: <Widget>[
              const _WelcomeSection(),
              const SizedBox(height: 32.0),
              const _QuickActionsSection(),
              const SizedBox(height: 32.0),
              const _ActivitySummarySection(),
              const SizedBox(height: 32.0),
              const _RecentActivitiesSection(),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
      // 
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

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
                width: 2.0
              ),
            ),
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Texto de Boas-vindas
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Olá, Dr. Silva',
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 20,),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Pronto para novas descobertas hoje?',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14,),
                )
              ],
            ),
          ),
        ],
      ),
    ); 
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // TODO
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 72),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add_circle_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Nova Coleta',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.displayLarge?.color, // Texto escuro no modo claro, branco no modo escuro
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
                  onTap: () {
                    // TODO
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SquareActionCard(
                  icon: Icons.sync,
                  label: 'Sincronizar Agora',
                  onTap: () {
                    // TODO
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget reutilizavel para os botoes quadrados
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
        )
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
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(height: 8.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
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
 
/*
  Vertical divider vai ser usado para o divisor vertical do figma saber a sua altura e poder
  se desenhar na tela. 
*/
class _ActivitySummarySection extends StatelessWidget {
  const _ActivitySummarySection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinha o titulo a esquerda
        children: <Widget>[
          Text(
            'RESUMO DAS ATIVIDADES',
            style: theme.textTheme.titleSmall?.copyWith(
              color: const Color(0xFF64748B), // Cor do Figma
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),

          // Caixa de Resumo
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),

            // O IntrinsicHeight faz a Row assumir a altura do mair elemento
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  // Lado ESQUERDO 
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '42', // TODO: tornar dinamico
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SINCRONIZADAS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ),

                  // LINHA VERTICAL
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),

                  // Lado DIREITO
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '03', // TODO: tornar dinamico
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PENDENTES',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RecentActivitiesSection extends StatelessWidget {
  const _RecentActivitiesSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ATIVIDADES RECENTES',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF64748B), // Cor do Figma
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.7,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO
                },
                child: Text(
                  'Ver tudo',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista de ITENS
          Column(
            children: <Widget>[
              _ActivityListItem(
                icon: Icons.location_on_outlined,
                title: 'Sitio Arqueologico Lapa do Sol',
                subtitle: 'Hoje, as 14:30 - Fragmentos Ceramicos',
                onTap: () {
                  // TODO
                },
              ),
              const SizedBox(height: 16),
              _ActivityListItem(
                icon: Icons.map_outlined,
                title: 'Vale dos Incas - Setor B',
                subtitle: 'Ontem - Mapeamento de Solo',
                onTap: () {
                  // TODO
                },
              ),
            ],
          )
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
        )
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
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
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
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Corta o texto com '...' se for muito grande
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Seta indicativa
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.error,
                size: 20,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}