import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColetasPage extends StatelessWidget {
  const ColetasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 16.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Minhas Coletas',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 18,
                  height: 1.2,
                ),
              ),
              const _OnlineIndicator(),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Column(
              children: <Widget>[
                const _SyncProgressBar(),
                TabBar(
                  isScrollable: true,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                  indicatorColor: theme.colorScheme.primary,
                  indicatorWeight: 2.0,
                  tabs: const <Widget>[
                    Tab(text: 'TODOS'),
                    Tab(text: 'PENDENTES'),
                    Tab(text: 'APROVADOS'),
                    Tab(text: 'REJEITADOS'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            _ListaColetas(),
            _ListaColetasPendentes(),
            _ListaColetasAprovadas(),
            _ListaColetasRejeitadas(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/nova-coleta');
          },
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _SyncProgressBar extends StatelessWidget {
  const _SyncProgressBar();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'SINCRONIZANDO DADOS...',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                '65%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: <Widget>[
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.65,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnlineIndicator extends StatelessWidget {
  const _OnlineIndicator();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80).withValues(alpha: 0.75),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          'Online',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _ListaColetas extends StatelessWidget {
  const _ListaColetas();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: 96.0,
      ),
      children: <Widget>[
        // 1. Nao sincronizado
        _ColetaCard(
          statusText: 'Não Sincronizado',
          statusColor: const Color(0xFF475569),
          statusBgColor: const Color(0xFFF1F5F9),
          title: 'Sítio Arqueológico Pedra Branca',
          location: 'Petrolina - PE',
          date: '12/10/2023',
          imageUrl:
              'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png', // Substitua pela imagem real
          actionsRow: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    'Editar',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sync, size: 16, color: Colors.white),
                  label: const Text(
                    'Sincronizar Agora',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Pendente
        _ColetaCard(
          statusText: 'Pendente de Curadoria',
          statusColor: const Color(0xFFA16207),
          statusBgColor: const Color(0xFFFEF9C3),
          title: 'Gruta do Eco',
          location: 'São Raimundo Nonato - PI',
          date: '08/10/2023',
          imageUrl:
              'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
          actionsRow: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/detalhes-coleta');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Ver Detalhes',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    'Editar',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Aprovado
        _ColetaCard(
          statusText: 'Aprovado',
          statusColor: const Color(0xFF15803D),
          statusBgColor: const Color(0xFFDCFCE7),
          title: 'Lapa do Sol',
          location: 'Iraquara - BA',
          date: '05/10/2023',
          imageUrl:
              'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
          actionsRow: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              elevation: 0,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: Text(
              'Ver Detalhes',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 4. Rejeitado
        _ColetaCard(
          statusText: 'Rejeitado',
          statusColor: const Color(0xFFB91C1C),
          statusBgColor: const Color(0xFFFEE2E2),
          title: 'Toca do Boi',
          location: 'Januária - MG',
          date: '01/10/2023',
          imageUrl:
              'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
          actionsRow: ElevatedButton(
            onPressed: () {
              context.go('/motivo-rejeicao');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEF2F2),
              side: const BorderSide(color: Color(0xFFFECACA)),
              elevation: 0,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text(
              'Ver Motivo da Rejeição',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ListaColetasAprovadas extends StatelessWidget {
  const _ListaColetasAprovadas();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: 96.0,
      ),
      children: <Widget>[
        // 3. Aprovado
        _ColetaCard(
          statusText: 'Aprovado',
          statusColor: const Color(0xFF15803D),
          statusBgColor: const Color(0xFFDCFCE7),
          title: 'Lapa do Sol',
          location: 'Iraquara - BA',
          date: '05/10/2023',
          imageUrl:
              'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
          actionsRow: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              elevation: 0,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: Text(
              'Ver Detalhes',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ListaColetasPendentes extends StatelessWidget {
  const _ListaColetasPendentes();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: 96.0,
      ),
      children: <Widget>[
        // Pendente
        _ColetaCard(
          statusText: 'Pendente de Curadoria',
          statusColor: const Color(0xFFA16207),
          statusBgColor: const Color(0xFFFEF9C3),
          title: 'Gruta do Eco',
          location: 'São Raimundo Nonato - PI',
          date: '08/10/2023',
          imageUrl:
              'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
          actionsRow: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Ver Detalhes',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    'Editar',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ListaColetasRejeitadas extends StatelessWidget {
  const _ListaColetasRejeitadas();

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: 96.0,
      ),
      children: <Widget>[
        // 4. Rejeitado
        _ColetaCard(
          statusText: 'Rejeitado',
          statusColor: const Color(0xFFB91C1C),
          statusBgColor: const Color(0xFFFEE2E2),
          title: 'Toca do Boi',
          location: 'Januária - MG',
          date: '01/10/2023',
          imageUrl:
              'https://mfeeee.github.io/portfolio-react/assets/profile-pic-QMyQxUnT.png',
          actionsRow: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEF2F2),
              side: const BorderSide(color: Color(0xFFFECACA)),
              elevation: 0,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text(
              'Ver Motivo da Rejeição',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ColetaCard extends StatelessWidget {
  const _ColetaCard({
    required this.statusText,
    required this.statusColor,
    required this.statusBgColor,
    required this.title,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.actionsRow,
  });

  final String statusText;
  final Color statusColor;
  final Color statusBgColor;
  final String title;
  final String location;
  final String date;
  final String imageUrl;
  final Widget actionsRow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 10,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Coletado em: $date',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          actionsRow,
        ],
      ),
    );
  }
}
