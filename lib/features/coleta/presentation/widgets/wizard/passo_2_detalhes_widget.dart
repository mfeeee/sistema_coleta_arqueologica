import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodels/coleta_form_notifier.dart';

class Passo2DetalhesWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController sinteseController;
  final ColetaFormNotifier formNotifier;
  final VoidCallback onVoltar;
  final VoidCallback onFinalizar;

  const Passo2DetalhesWidget({
    super.key,
    required this.formKey,
    required this.sinteseController,
    required this.formNotifier,
    required this.onVoltar,
    required this.onFinalizar,
  });

  @override
  State<Passo2DetalhesWidget> createState() => _Passo2DetalhesWidgetState();
}

class _Passo2DetalhesWidgetState extends State<Passo2DetalhesWidget> {
  bool _gravandoAudio = false;

  final Color bgColor = const Color(0xFF1C1916);
  final Color primaryBrown = const Color(0xFF493627);
  final Color textLight = const Color(0xFFF1F5F9);
  final Color textMuted = const Color(0xFF94A3B8);
  final Color inputText = const Color(0xFFE2E8F0);

  Color get borderColor => const Color(0xFF493627).withValues(alpha: 0.2);

  void _alternarGravacao() {
    setState(() => _gravandoAudio = !_gravandoAudio);
  }

  void _escolherFonte() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: primaryBrown,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Câmera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.formNotifier.adicionarFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Galeria',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.formNotifier.adicionarFoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProgressStep(color: primaryBrown.withValues(alpha: 0.2)),
                const SizedBox(width: 12),
                _ProgressStep(color: primaryBrown),
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
                    titulo: 'Descrição e Acesso',
                    badgeTexto: 'ÁUDIO',
                    textLight: textLight,
                    primaryBrown: primaryBrown,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque no microfone para descrever as características '
                    'do solo ou artefatos encontrados.',
                    style: TextStyle(color: textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  _BotaoMicrofone(
                    gravando: _gravandoAudio,
                    primaryBrown: primaryBrown,
                    textMuted: textMuted,
                    onTap: _alternarGravacao,
                  ),
                  const SizedBox(height: 20),
                  _RotuloSecao(
                    'TRANSCRIÇÃO OU NOTAS MANUAIS (OPCIONAL)',
                    textColor: textLight,
                  ),
                  const SizedBox(height: 8),
                  _CampoTexto(
                    controller: widget.sinteseController,
                    borderColor: borderColor,
                    textColor: inputText,
                    hintText:
                        'Insira notas adicionais sobre os meios de '
                        'acesso ou detalhes técnicos...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  _CabecalhoSecao(
                    titulo: 'Evidências Visuais',
                    badgeTexto: 'CÂMERA',
                    textLight: textLight,
                    primaryBrown: primaryBrown,
                  ),
                  const SizedBox(height: 16),
                  _BotaoCapturar(
                    primaryBrown: primaryBrown,
                    textMuted: textMuted,
                    onTap: _escolherFonte,
                  ),
                  if (widget.formNotifier.totalFotos > 0) ...[
                    const SizedBox(height: 12),
                    _GradeMiniaturas(
                      fotos: widget.formNotifier.fotos,
                      onRemover: widget.formNotifier.removerFoto,
                    ),
                  ],
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: widget.onFinalizar,
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'Finalizar e Salvar Coleta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBrown,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: primaryBrown.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'A COLETA SERÁ SALVA LOCALMENTE E NA PRÓXIMA '
                    'SINCRONIZAÇÃO SERÁ ENVIADA.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textMuted,
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
                        color: textMuted,
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
                color: Colors.white,
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
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
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

class _BotaoCapturar extends StatelessWidget {
  final Color primaryBrown;
  final Color textMuted;
  final VoidCallback onTap;

  const _BotaoCapturar({
    required this.primaryBrown,
    required this.textMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          border: Border.all(color: primaryBrown.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: primaryBrown, size: 32),
            const SizedBox(height: 8),
            Text(
              'CAPTURAR',
              style: TextStyle(
                color: textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeMiniaturas extends StatelessWidget {
  final List<File> fotos;
  final void Function(int) onRemover;

  static const int _maxVisiveis = 3;

  const _GradeMiniaturas({required this.fotos, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    final int exibindo = fotos.length > _maxVisiveis
        ? _maxVisiveis
        : fotos.length;
    final int extras = fotos.length - _maxVisiveis;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exibindo,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final bool isUltima = index == _maxVisiveis - 1 && extras > 0;
        return GestureDetector(
          onLongPress: () => onRemover(index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(fotos[index], fit: BoxFit.cover),
                if (isUltima)
                  ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: Text(
                        '+$extras',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
