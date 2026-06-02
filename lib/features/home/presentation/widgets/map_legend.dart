import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/tipo_pino.dart';
import 'package:sistema_coleta_arqueologica/features/home/presentation/widgets/pino_marker.dart';

class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: TipoPino.values
                .where((t) => t != TipoPino.padrao)
                .map((t) => _LegendaItem(tipo: t))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _LegendaItem extends StatelessWidget {
  const _LegendaItem({required this.tipo});

  final TipoPino tipo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cor = PinoMarker.corPorTipo(tipo, colorScheme);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            tipo.rotulo,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
