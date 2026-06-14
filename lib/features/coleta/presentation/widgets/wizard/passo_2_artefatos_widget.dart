import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/di/app_scope.dart';
import '../../viewmodels/coleta_form_notifier.dart';
import '../artefato_tipo_picker.dart';

class Passo2ArtefatosWidget extends StatelessWidget {
  final ColetaFormNotifier formNotifier;
  final VoidCallback onVoltar;
  final VoidCallback onAvancar;

  const Passo2ArtefatosWidget({
    super.key,
    required this.formNotifier,
    required this.onVoltar,
    required this.onAvancar,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scope = AppScope.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProgressStep(
                  color: cs.primaryContainer.withValues(alpha: 0.25),
                ),
                const SizedBox(width: 12),
                _ProgressStep(color: cs.primaryContainer),
                const SizedBox(width: 12),
                _ProgressStep(
                  color: cs.primaryContainer.withValues(alpha: 0.25),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              children: [
                Text(
                  'TIPOS DE ARTEFATO',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selecione os que foram identificados ou adicione um novo tipo.',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                ),
                const SizedBox(height: 20),

                ListenableBuilder(
                  listenable: formNotifier,
                  builder: (context, _) {
                    return ArtefatoTipoPicker(
                      selectedTypes: formNotifier.artefatos,
                      onChanged: formNotifier.setArtefatos,
                      dio: scope
                          .dioPublic, // Use dioPublic if it doesn't need auth, or just scope.dio
                    );
                  },
                ),

                const SizedBox(height: 48),

                ElevatedButton(
                  onPressed: onAvancar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primaryContainer,
                    foregroundColor: cs.onPrimaryContainer,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Próximo Passo: Documentação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: cs.onPrimaryContainer,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onVoltar,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'VOLTAR',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
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

class _ProgressStep extends StatelessWidget {
  final Color color;
  const _ProgressStep({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
