import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import 'package:sistema_coleta_arqueologica/core/extensions/context_extensions.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/auth/auth_notifier.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/pino_mapa.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/tipo_pino.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/activity_summary_section.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/map_legend.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/pino_marker.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/recent_activities_section.dart';
import 'package:speech_to_text/speech_to_text.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late final HomeViewModel _viewModel;
  late final AuthNotifier _authNotifier;
  late final ValueNotifier<bool> _estaOnline;
  late final ValueNotifier<String?> _fotoPerfilPath;
  late final MapController _mapController;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final scope = AppScope.of(context);
      _authNotifier = scope.authNotifier;
      _estaOnline = scope.conectividadeService.estaOnline;
      _fotoPerfilPath = scope.fotoPerfilPath;
      _mapController = MapController();
      _viewModel = HomeViewModel(
        coletaRepository: scope.coletaRepository,
        bemMaterialRepository: scope.bemMaterialRepository,
        authNotifier: scope.authNotifier,
      );
      _viewModel.carregarDados();
      _authNotifier.addListener(_onAuthAlterado);
      _authNotifier.contadorSyncBens.addListener(_viewModel.carregarDados);
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
    _authNotifier.contadorSyncBens.removeListener(_viewModel.carregarDados);
    _viewModel.dispose();
    _mapController.dispose();
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
    final peekBottom = screenHeight * 0.175 + 16.0;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _MapaLayer(
            pinosNoMapa: _viewModel.pinosNoMapa,
            mapController: _mapController,
          ),
          Positioned(left: 16.0, bottom: peekBottom, child: const MapLegend()),
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
              estaOnline: _estaOnline,
              fotoPerfilPath: _fotoPerfilPath,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                _FloatingHeader(
                  topPadding: topPadding,
                  authNotifier: _authNotifier,
                  fotoPerfilPath: _fotoPerfilPath,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _FloatingSearchBar(
                    mapController: _mapController,
                    pinosNoMapa: _viewModel.pinosNoMapa,
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

// ── Camada do mapa ────────────────────────────────────────────────────────────

class _MapaLayer extends StatefulWidget {
  const _MapaLayer({required this.pinosNoMapa, required this.mapController});

  final ValueNotifier<List<PinoMapa>> pinosNoMapa;
  final MapController mapController;

  @override
  State<_MapaLayer> createState() => _MapaLayerState();
}

class _MapaLayerState extends State<_MapaLayer> {
  static const LatLng _centroInicial = LatLng(-2.905, -41.776);

  @override
  void initState() {
    super.initState();
    _inicializarLocalizacao();
  }

  Future<void> _inicializarLocalizacao() async {
    try {
      var permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }
      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        return;
      }
      final posicao = await Geolocator.getCurrentPosition().timeout(
        const Duration(seconds: 8),
      );
      if (mounted) {
        widget.mapController.move(
          LatLng(posicao.latitude, posicao.longitude),
          15.0,
        );
      }
    } catch (e) {
      log('Geolocalização indisponível', name: '_MapaLayer', error: e);
    }
  }

  static void _navegarParaPino(BuildContext context, PinoMapa pino) {
    switch (pino.tipo) {
      case TipoPino.bemPublicado:
        context.push('/bem-material/${pino.id}');
      case TipoPino.coleta:
      case TipoPino.padrao:
        context.push('/detalhes-coleta', extra: pino.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PinoMapa>>(
      valueListenable: widget.pinosNoMapa,
      builder: (context, pinos, _) {
        final colorScheme = Theme.of(context).colorScheme;
        return FlutterMap(
          mapController: widget.mapController,
          options: const MapOptions(
            initialCenter: _centroInicial,
            initialZoom: 13.0,
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'br.edu.ifpi.arqueadata',
              tileProvider: FMTCTileProvider(
                stores: const {
                  'arqueologico': BrowseStoreStrategy.readUpdateCreate,
                },
              ),
            ),
            MarkerLayer(
              markers: pinos
                  .map(
                    (p) => Marker(
                      point: p.posicao,
                      width: 16,
                      height: 16,
                      child: GestureDetector(
                        onTap: () => _navegarParaPino(context, p),
                        child: PinoMarker(
                          tipo: p.tipo,
                          colorScheme: colorScheme,
                        ),
                      ),
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

String _iniciais(String? nome) {
  if (nome == null || nome.isEmpty) return '?';
  final partes = nome.trim().split(RegExp(r'\s+'));
  if (partes.length == 1) return partes[0][0].toUpperCase();
  return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
}

class _FloatingHeader extends StatelessWidget {
  const _FloatingHeader({
    required this.topPadding,
    required this.authNotifier,
    required this.fotoPerfilPath,
  });

  final double topPadding;
  final AuthNotifier authNotifier;
  final ValueNotifier<String?> fotoPerfilPath;

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
                      'ArqueoPI',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hub Coletas v1.0',
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
              Semantics(
                label: 'Ir para perfil',
                button: true,
                child: GestureDetector(
                  onTap: () => context.push('/perfil'),
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      authNotifier,
                      fotoPerfilPath,
                    ]),
                    builder: (context, _) {
                      final caminho = fotoPerfilPath.value;
                      if (caminho != null) {
                        return CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(caminho),
                        );
                      }
                      return CircleAvatar(
                        radius: 18,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          _iniciais(authNotifier.userName),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingSearchBar extends StatefulWidget {
  const _FloatingSearchBar({
    required this.mapController,
    required this.pinosNoMapa,
  });

  final MapController mapController;
  final ValueNotifier<List<PinoMapa>> pinosNoMapa;

  @override
  State<_FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<_FloatingSearchBar> {
  final _controller = TextEditingController();
  final _overlayController = OverlayPortalController();
  final _layerLink = LayerLink();
  List<PinoMapa> _sugestoes = [];
  bool _estaGravando = false;

  static final _regexCoordenada = RegExp(
    r'^([-+]?\d+(?:\.\d+)?)\s*[,;]\s*([-+]?\d+(?:\.\d+)?)$',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _aoMudar(String texto) {
    final trimmed = texto.trim();
    if (trimmed.isEmpty) {
      _overlayController.hide();
      setState(() => _sugestoes = []);
      return;
    }

    final match = _regexCoordenada.firstMatch(trimmed);
    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        widget.mapController.move(LatLng(lat, lng), 15.0);
        _overlayController.hide();
        setState(() => _sugestoes = []);
        return;
      }
    }

    final lower = trimmed.toLowerCase();
    final resultados = widget.pinosNoMapa.value
        .where((p) => p.nomeBem.toLowerCase().contains(lower))
        .take(5)
        .toList();
    setState(() => _sugestoes = resultados);
    if (resultados.isNotEmpty) {
      _overlayController.show();
    } else {
      _overlayController.hide();
    }
  }

  void _selecionarPino(PinoMapa pino) {
    widget.mapController.move(pino.posicao, 15.0);
    _controller.clear();
    _overlayController.hide();
    setState(() => _sugestoes = []);
  }

  void _limpar() {
    _controller.clear();
    _overlayController.hide();
    setState(() => _sugestoes = []);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) {
          final width = MediaQuery.sizeOf(context).width - 32;
          return CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 4),
            child: SizedBox(
              width: width,
              child: _ListaSugestoes(
                sugestoes: _sugestoes,
                onSelecionar: _selecionarPino,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.4,
                  ),
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
                    child: TextField(
                      controller: _controller,
                      onChanged: _aoMudar,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Buscar sítio ou coordenada...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) {
                      if (value.text.isNotEmpty && !_estaGravando) {
                        return GestureDetector(
                          onTap: _limpar,
                          child: Icon(
                            Icons.close,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        );
                      }
                      return _BotaoMicrofone(
                        controller: _controller,
                        onTextoReconhecido: _aoMudar,
                        onGravandoMudou: (gravando) =>
                            setState(() => _estaGravando = gravando),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotaoMicrofone extends StatefulWidget {
  const _BotaoMicrofone({
    required this.controller,
    required this.onTextoReconhecido,
    required this.onGravandoMudou,
  });

  final TextEditingController controller;
  final ValueChanged<String> onTextoReconhecido;
  final ValueChanged<bool> onGravandoMudou;

  @override
  State<_BotaoMicrofone> createState() => _BotaoMicrofoneState();
}

class _BotaoMicrofoneState extends State<_BotaoMicrofone> {
  final _stt = SpeechToText();
  bool _disponivel = false;
  bool _ouvindo = false;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  @override
  void dispose() {
    _stt.cancel();
    super.dispose();
  }

  Future<void> _inicializar() async {
    try {
      final disponivel = await _stt.initialize(
        onError: (e) {
          log('STT erro: ${e.errorMsg}', name: '_BotaoMicrofone');
          if (mounted) {
            setState(() => _ouvindo = false);
            widget.onGravandoMudou(false);
          }
        },
        onStatus: (status) {
          if (!mounted) return;
          final gravando = _stt.isListening;
          if (_ouvindo != gravando) {
            setState(() => _ouvindo = gravando);
            widget.onGravandoMudou(gravando);
          }
        },
      );
      if (mounted) setState(() => _disponivel = disponivel);
    } catch (e) {
      log(
        'STT indisponível nesta plataforma',
        name: '_BotaoMicrofone',
        error: e,
      );
    }
  }

  Future<void> _alternar() async {
    if (_ouvindo) {
      await _stt.stop();
      return;
    }
    await _stt.listen(
      onResult: (resultado) {
        if (!mounted) return;
        final texto = resultado.recognizedWords;
        widget.controller.value = TextEditingValue(
          text: texto,
          selection: TextSelection.collapsed(offset: texto.length),
        );
        widget.onTextoReconhecido(texto);
      },
      listenOptions: SpeechListenOptions(
        pauseFor: const Duration(seconds: 3),
        localeId: 'pt_BR',
        enableHapticFeedback: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_disponivel) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _alternar,
      child: Icon(
        _ouvindo ? Icons.mic : Icons.mic_none,
        color: _ouvindo
            ? AppColors.warningAlt
            : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }
}

class _ListaSugestoes extends StatelessWidget {
  const _ListaSugestoes({required this.sugestoes, required this.onSelecionar});

  final List<PinoMapa> sugestoes;
  final ValueChanged<PinoMapa> onSelecionar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: sugestoes
                .map((p) => _SugestaoItem(pino: p, onTap: onSelecionar))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _SugestaoItem extends StatelessWidget {
  const _SugestaoItem({required this.pino, required this.onTap});

  final PinoMapa pino;
  final ValueChanged<PinoMapa> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cor = PinoMarker.corPorTipo(pino.tipo, theme.colorScheme);
    return InkWell(
      onTap: () => onTap(pino),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                pino.nomeBem,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              pino.tipo.rotulo,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom sheet ──────────────────────────────────────────────────────────────

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({
    required this.scrollController,
    required this.viewModel,
    required this.onNovaColeta,
    required this.estaOnline,
    required this.fotoPerfilPath,
  });

  final ScrollController scrollController;
  final HomeViewModel viewModel;
  final VoidCallback onNovaColeta;
  final ValueNotifier<bool> estaOnline;
  final ValueNotifier<String?> fotoPerfilPath;

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
          ValueListenableBuilder<bool>(
            valueListenable: estaOnline,
            builder: (context, online, _) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: online
                  ? const SizedBox.shrink(key: ValueKey('online'))
                  : const _OfflineBanner(key: ValueKey('offline')),
            ),
          ),
          const SizedBox(height: 8),
          _WelcomeSection(
            nomeUsuario: viewModel.nomeUsuario,
            fotoPerfilPath: fotoPerfilPath,
          ),
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

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningAlt.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningAlt.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.wifi_off, color: AppColors.warningAlt, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sem conexão — dados serão sincronizados ao reconectar',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.warningAlt,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
  const _WelcomeSection({
    required this.nomeUsuario,
    required this.fotoPerfilPath,
  });

  final ValueNotifier<String> nomeUsuario;
  final ValueNotifier<String?> fotoPerfilPath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          ListenableBuilder(
            listenable: Listenable.merge([nomeUsuario, fotoPerfilPath]),
            builder: (context, _) {
              final caminho = fotoPerfilPath.value;
              return Container(
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
                child: caminho != null
                    ? CircleAvatar(backgroundImage: NetworkImage(caminho))
                    : CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          _iniciais(nomeUsuario.value),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            },
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
