import 'package:flutter/material.dart';
import '../../viewmodels/coleta_form_notifier.dart';
import '../foto_picker_widget.dart';

class Passo3DetalhesWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ColetaFormNotifier formNotifier;
  final VoidCallback onVoltar;
  final VoidCallback onFinalizar;

  const Passo3DetalhesWidget({
    super.key,
    required this.formKey,
    required this.formNotifier,
    required this.onVoltar,
    required this.onFinalizar,
  });

  @override
  State<Passo3DetalhesWidget> createState() => _Passo3DetalhesWidgetState();
}

class _Passo3DetalhesWidgetState extends State<Passo3DetalhesWidget> {
  bool _gravandoAudio = false;
  late final TextEditingController _meiosAcessoController;

  @override
  void initState() {
    super.initState();
    _meiosAcessoController = TextEditingController(
      text: widget.formNotifier.meiosAcesso,
    );
    _meiosAcessoController.addListener(() {
      widget.formNotifier.setMeiosAcesso(_meiosAcessoController.text);
    });
  }

  @override
  void dispose() {
    _meiosAcessoController.dispose();
    super.dispose();
  }

  void _alternarGravacao() {
    setState(() => _gravandoAudio = !_gravandoAudio);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = cs.primaryContainer.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProgressStep(
                  color: cs.primaryContainer.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 12),
                _ProgressStep(
                  color: cs.primaryContainer.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 12),
                _ProgressStep(color: cs.primaryContainer),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: widget.formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 48.0),
                children: [
                  _CabecalhoSecao(
                    titulo: 'Meios de Acesso',
                    badgeTexto: 'ÁUDIO',
                    textLight: cs.onSurface,
                    primaryBrown: cs.primaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque no microfone para descrever os meios de acesso.',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  _BotaoMicrofone(
                    gravando: _gravandoAudio,
                    primaryBrown: cs.primaryContainer,
                    textMuted: cs.onSurfaceVariant,
                    onTap: _alternarGravacao,
                  ),
                  const SizedBox(height: 20),
                  _RotuloSecao(
                    'TRANSCRIÇÃO OU NOTAS MANUAIS (OPCIONAL)',
                    textColor: cs.onSurface,
                  ),
                  const SizedBox(height: 8),
                  _CampoTexto(
                    controller: _meiosAcessoController,
                    borderColor: borderColor,
                    textColor: cs.onSurface,
                    hintText:
                        'Insira notas adicionais sobre os meios de '
                        'acesso...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  _CabecalhoSecao(
                    titulo: 'Evidências Visuais',
                    badgeTexto: 'CÂMERA',
                    textLight: cs.onSurface,
                    primaryBrown: cs.primaryContainer,
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: widget.formNotifier,
                    builder: (context, _) {
                      return FotoPickerWidget(
                        midias: widget.formNotifier.midias,
                        carregando: widget.formNotifier.carregandoMidia,
                        onPick: widget.formNotifier.adicionarFoto,
                        onRemover: widget.formNotifier.removerMidia,
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: widget.onFinalizar,
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: cs.onPrimaryContainer,
                      size: 20,
                    ),
                    label: Text(
                      'Finalizar e Salvar Coleta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primaryContainer,
                      foregroundColor: cs.onPrimaryContainer,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: cs.primaryContainer.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'A COLETA SERÁ SALVA LOCALMENTE E NA PRÓXIMA '
                    'SINCRONIZAÇÃO SERÁ ENVIADA.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onVoltar,
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

class _CabecalhoSecao extends StatelessWidget {
  final String titulo;
  final String badgeTexto;
  final Color textLight;
  final Color primaryBrown;

  const _CabecalhoSecao({
    required this.titulo,
    required this.badgeTexto,
    required this.textLight,
    required this.primaryBrown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: textLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: primaryBrown.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryBrown.withValues(alpha: 0.3)),
          ),
          child: Text(
            badgeTexto,
            style: TextStyle(
              color: primaryBrown,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _BotaoMicrofone extends StatelessWidget {
  final bool gravando;
  final Color primaryBrown;
  final Color textMuted;
  final VoidCallback onTap;

  const _BotaoMicrofone({
    required this.gravando,
    required this.primaryBrown,
    required this.textMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryBrown,
                boxShadow: [
                  BoxShadow(
                    color: primaryBrown.withValues(alpha: 0.45),
                    blurRadius: 18,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                gravando ? Icons.stop_rounded : Icons.mic,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gravando ? 'GRAVANDO...' : 'TOQUE PARA GRAVAR',
            style: TextStyle(
              color: textMuted,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RotuloSecao extends StatelessWidget {
  final String text;
  final Color textColor;

  const _RotuloSecao(this.text, {required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.7,
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final Color borderColor;
  final Color textColor;
  final String hintText;
  final int maxLines;

  const _CampoTexto({
    required this.controller,
    required this.borderColor,
    required this.textColor,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
      ),
    );
  }
}
