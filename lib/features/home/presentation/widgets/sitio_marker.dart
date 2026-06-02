import 'package:flutter/material.dart';

class SitioMarker extends StatelessWidget {
  const SitioMarker({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.onPrimary, width: 2.0),
      ),
    );
  }
}
