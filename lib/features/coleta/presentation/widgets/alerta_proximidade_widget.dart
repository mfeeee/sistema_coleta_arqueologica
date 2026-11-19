import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/entities/coleta_entity.dart';
import 'package:sistema_coleta_arqueologica/features/coleta/domain/services/proximidade_service.dart';

class AlertaProximidadeWidget extends StatelessWidget {
  const AlertaProximidadeWidget({
    super.key,
    required this.sitios,
    required this.latAtual,
    required this.lonAtual,
    required this.onProsseguir,
    required this.onEscolherSitio,
  });

  final List<ColetaEntity> sitios;
  final double latAtual;
  final double lonAtual;
  final VoidCallback onProsseguir;
  final void Function(ColetaEntity sitio) onEscolherSitio;

  @override
  Widget build(BuildContext context) {
    final ordenados = _ordenarPorDistancia(sitios);
    final maisProximo = ordenados.first;
    final demais = ordenados.skip(1).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CabecalhoAlerta(
              nomeSitio: maisProximo.sitio.nomeBem,
              distancia: maisProximo.distanciaMetros,
              onTap: () => onEscolherSitio(maisProximo.sitio),
            ),
            if (demais.isNotEmpty) ...[
              const SizedBox(height: 16),
              _ListaOutrosSitios(sitios: demais, onTap: onEscolherSitio),
            ],
            const SizedBox(height: 32),
            _BotoesAcao(
              sitioId: maisProximo.sitio.id,
              onProsseguir: onProsseguir,
            ),
          ],
        ),
      ),
    );
  }

  List<_SitioComDistancia> _ordenarPorDistancia(List<ColetaEntity> lista) {
    final comDistancia =
        lista
            .where(
              (s) => s.localizacao?.lat != null && s.localizacao?.lng != null,
            )
            .map(
              (s) => _SitioComDistancia(
                sitio: s,
                distanciaMetros: ProximidadeService.calcularDistanciaMetros(
                  latAtual,
                  lonAtual,
                  s.localizacao!.lat!,
                  s.localizacao!.lng!,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.distanciaMetros.compareTo(b.distanciaMetros));
    return comDistancia;
  }
}

class _SitioComDistancia {
  const _SitioComDistancia({
    required this.sitio,
    required this.distanciaMetros,
  });

  final ColetaEntity sitio;
  final double distanciaMetros;
}

String _formatarDistancia(double metros) {
  if (metros < 1000) return '${metros.round()} m';
  return '${(metros / 1000).toStringAsFixed(1)} km';
}

class _CabecalhoAlerta extends StatelessWidget {
  const _CabecalhoAlerta({
    required this.nomeSitio,
    required this.distancia,
    required this.onTap,
  });

  final String nomeSitio;
  final double distancia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const corAlerta = AppColors.warningAlt;
    const corAlertaBg = AppColors.warningBg;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corAlerta.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: corAlertaBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: corAlerta,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sítio Arqueológico Próximo',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Existe um registro a menos de 500m da sua localização. '
            'Toque num sítio para modificá-lo, ou continue com um registro '
            'novo: o curador vai analisar.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          Material(
            color: corAlertaBg,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: corAlerta,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeSitio.isNotEmpty ? nomeSitio : 'Sítio sem nome',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatarDistancia(distancia),
                            style: const TextStyle(
                              color: corAlerta,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: corAlerta),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListaOutrosSitios extends StatelessWidget {
  const _ListaOutrosSitios({required this.sitios, required this.onTap});

  final List<_SitioComDistancia> sitios;
  final void Function(ColetaEntity sitio) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            'OUTROS SÍTIOS PRÓXIMOS (${sitios.length})',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sitios.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
            ),
            itemBuilder: (_, i) {
              final item = sitios[i];
              return InkWell(
                onTap: () => onTap(item.sitio),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: theme.colorScheme.primary.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.sitio.nomeBem.isNotEmpty
                              ? item.sitio.nomeBem
                              : 'Sítio sem nome',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        _formatarDistancia(item.distanciaMetros),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.primary.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BotoesAcao extends StatelessWidget {
  const _BotoesAcao({required this.sitioId, required this.onProsseguir});

  final String sitioId;
  final VoidCallback onProsseguir;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => context.push('/detalhes-coleta', extra: sitioId),
          icon: const Icon(Icons.open_in_new, size: 18),
          label: const Text(
            'Ver Detalhes do Sítio',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onProsseguir,
          child: const Text(
            'Continuar com registro novo',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
