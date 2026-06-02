import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';
import 'package:sistema_coleta_arqueologica/features/home/domain/entities/tipo_pino.dart';

class PinoMarker extends StatelessWidget {
  const PinoMarker({super.key, required this.tipo, required this.colorScheme});

  final TipoPino tipo;
  final ColorScheme colorScheme;

  static Color corPorTipo(TipoPino tipo, ColorScheme cores) => switch (tipo) {
    TipoPino.coleta => AppColors.warningAlt,
    TipoPino.bemPublicado => cores.primaryContainer,
    TipoPino.padrao => cores.primaryContainer,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: corPorTipo(tipo, colorScheme),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.0),
      ),
    );
  }
}
