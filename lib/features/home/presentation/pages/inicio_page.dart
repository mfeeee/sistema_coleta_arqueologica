import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/sitio_mapa_entity.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/activity_summary_section.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/recent_activities_section.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/sitio_marker.dart';

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
    final topPadding = MediaQuery.paddingOf(context).top;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _MapaLayer(sitiosNoMapa: _viewModel.sitiosNoMapa),
          DraggableScrollableSheet(
            initialChildSize: 0.175,
            minChildSize: 0.175,
            maxChildSize: 0.92,
            snap: true,
            snapSizes: const [0.175, 0.5, 0.92],
            builder: (context, scrollController) => _BottomSheetContent(
              scrollController: scrollController,
              viewModel: _viewModel,
              onNovaColeta: _irParaNovaColeta,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                _FloatingHeader(topPadding: topPadding),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _FloatingSearchBar(),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: screenHeight * 0.175 + 16.0,
            child: _FloatingFab(onPressed: _irParaNovaColeta),
          ),
        ],
      ),
    );
  }
}

// ── Camada do mapa ────────────────────────────────────────────────────────────

class _MapaLayer extends StatelessWidget {
  const _MapaLayer({required this.sitiosNoMapa});

  final ValueNotifier<List<SitioMapaEntity>> sitiosNoMapa;

  // Parnaíba, PI — coordenada fixa até geolocator real ser integrado.
  static const LatLng _centroInicial = LatLng(-2.905, -41.776);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SitioMapaEntity>>(
      valueListenable: sitiosNoMapa,
      builder: (context, sitios, _) {
        return FlutterMap(
          options: const MapOptions(
            initialCenter: _centroInicial,
            initialZoom: 13.0,
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'br.edu.ifpi.arqueadata',
            ),
            MarkerLayer(
              markers: sitios
                  .map(
                    (s) => Marker(
                      point: s.posicao,
                      width: 16,
                      height: 16,
                      child: const SitioMarker(),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

// ── Elementos flutuantes ──────────────────────────────────────────────────────

class _FloatingHeader extends StatelessWidget {
  const _FloatingHeader({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.85),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'A',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'ArqueoData',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Field Collection v2.4',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: theme.colorScheme.onSurface,
                  size: 22,
                ),
                onPressed: () => context.push('/notificacoes'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingSearchBar extends StatelessWidget {
  const _FloatingSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Buscar sítio ou coordenada...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                Icons.mic_none,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingFab extends StatelessWidget {
  const _FloatingFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4,
      child: const Icon(Icons.add),
    );
  }
}

// ── Bottom sheet ──────────────────────────────────────────────────────────────

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({
    required this.scrollController,
    required this.viewModel,
    required this.onNovaColeta,
  });

  final ScrollController scrollController;
  final HomeViewModel viewModel;
  final VoidCallback onNovaColeta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.only(bottom: bottomPadding + 32),
        children: <Widget>[
          const _SheetHandle(),
          const SizedBox(height: 8),
          _WelcomeSection(nomeUsuario: viewModel.nomeUsuario),
          ValueListenableBuilder<int>(
            valueListenable: viewModel.coletasPendentes,
            builder: (context, qtd, _) {
              if (qtd == 0) return const SizedBox.shrink();
              return _BannerPendentes(quantidade: qtd);
            },
          ),
          const SizedBox(height: 24),
          _QuickActionsSection(onNovaColeta: onNovaColeta),
          const SizedBox(height: 24),
          ActivitySummarySection(
            totalColetas: viewModel.totalColetas,
            coletasPendentes: viewModel.coletasPendentes,
          ),
          const SizedBox(height: 24),
          RecentActivitiesSection(coletasRecentes: viewModel.coletasRecentes),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ── Conteúdo do sheet ─────────────────────────────────────────────────────────

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
