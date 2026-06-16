import 'package:flutter/material.dart';
import '../../../../core/database/enums/tipo_midia.dart';
import '../../../../core/models/midia_model.dart';

class MidiaViewer extends StatelessWidget {
  final MidiaModel midia;
  final double? width;
  final double? height;
  final BoxFit fit;

  const MidiaViewer({
    super.key,
    required this.midia,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (midia.tipo == TipoMidia.imagem) {
      return Image.network(
        midia.url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildError(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoading();
        },
      );
    } else if (midia.tipo == TipoMidia.video) {
      return Container(
        width: width,
        height: height,
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
              SizedBox(height: 8),
              Text(
                'Player de Vídeo',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    } else {
      return _buildError(message: 'Tipo não suportado');
    }
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildError({String message = 'Erro ao carregar'}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 24),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
