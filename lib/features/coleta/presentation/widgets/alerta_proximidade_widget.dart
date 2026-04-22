import 'package:flutter/material.dart';

class AlertaProximidadeWidget extends StatelessWidget {
  final List<dynamic> sitios; // TODO: Tipar
  final VoidCallback onProsseguir;

  const AlertaProximidadeWidget({
    super.key,
    required this.sitios,
    required this.onProsseguir,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Montar o visual do Alerta (Ícone de aviso, textos e o botão para onProsseguir)
    return const Placeholder(fallbackHeight: 200);
  }
}
