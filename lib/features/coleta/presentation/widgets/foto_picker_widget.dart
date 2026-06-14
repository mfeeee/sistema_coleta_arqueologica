import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/models/midia_model.dart';
import '../../../media/presentation/widgets/midia_viewer.dart';

class FotoPickerWidget extends StatelessWidget {
  final List<MidiaModel> midias;
  final bool carregando;
  final Function(ImageSource) onPick;
  final Function(int) onRemover;

  const FotoPickerWidget({
    super.key,
    required this.midias,
    required this.carregando,
    required this.onPick,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primaryBrown = cs.primaryContainer;
    final textMuted = cs.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (carregando)
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: LinearProgressIndicator(),
          ),
        _BotaoCapturar(
          primaryBrown: primaryBrown,
          textMuted: textMuted,
          onTap: () => _escolherFonte(context),
        ),
        if (midias.isNotEmpty) ...[
          const SizedBox(height: 12),
          _GradeMiniaturas(midias: midias, onRemover: onRemover),
        ],
      ],
    );
  }

  void _escolherFonte(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.primaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: cs.onPrimaryContainer),
              title: Text(
                'Câmera',
                style: TextStyle(color: cs.onPrimaryContainer),
              ),
              onTap: () {
                Navigator.pop(context);
                onPick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: cs.onPrimaryContainer),
              title: Text(
                'Galeria',
                style: TextStyle(color: cs.onPrimaryContainer),
              ),
              onTap: () {
                Navigator.pop(context);
                onPick(ImageSource.gallery);
              },
            ),
          ],
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
  final List<MidiaModel> midias;
  final void Function(int) onRemover;

  static const int _maxVisiveis = 3;

  const _GradeMiniaturas({required this.midias, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    final int exibindo = midias.length > _maxVisiveis
        ? _maxVisiveis
        : midias.length;
    final int extras = midias.length - _maxVisiveis;

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
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              MidiaViewer(midia: midias[index]),
              if (isUltima)
                ColoredBox(
                  color: Theme.of(
                    context,
                  ).colorScheme.scrim.withValues(alpha: 0.54),
                  child: Center(
                    child: Text(
                      '+$extras',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onRemover(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
