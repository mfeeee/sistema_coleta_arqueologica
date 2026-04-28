import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/artefato_bem.dart';
import '../../viewmodels/coleta_form_notifier.dart';

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

  static const Color _bgColor = Color(0xFF1C1916);
  static const Color _primaryBrown = Color(0xFF493627);
  static const Color _textLight = Color(0xFFF1F5F9);
  static const Color _textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProgressStep(color: _primaryBrown.withValues(alpha: 0.25)),
                const SizedBox(width: 12),
                const _ProgressStep(color: _primaryBrown),
                const SizedBox(width: 12),
                _ProgressStep(color: _primaryBrown.withValues(alpha: 0.25)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              children: [
                const Text(
                  'TIPOS DE ARTEFATO',
                  style: TextStyle(
                    color: _textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Selecione todos os que foram identificados no campo.',
                  style: TextStyle(color: _textMuted, fontSize: 13),
                ),
                const SizedBox(height: 20),

                ListenableBuilder(
                  listenable: formNotifier,
                  builder: (context, _) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ArtefatoBem.values.map((artefato) {
                        final selecionado = formNotifier.isArtefatoSelecionado(
                          artefato,
                        );
                        return FilterChip(
                          label: Text(artefato.label),
                          selected: selecionado,
                          onSelected: (_) =>
                              formNotifier.toggleArtefato(artefato),
                          backgroundColor: _bgColor,
                          selectedColor: _primaryBrown,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selecionado ? Colors.white : _textMuted,
                            fontSize: 16,
                            fontWeight: selecionado
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: selecionado
                                ? _primaryBrown
                                : _primaryBrown.withValues(alpha: 0.25),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 48),

                ElevatedButton(
                  onPressed: onAvancar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBrown,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Próximo Passo: Documentação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onVoltar,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'VOLTAR',
                    style: TextStyle(
                      color: _textMuted,
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
