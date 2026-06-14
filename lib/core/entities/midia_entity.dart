import '../database/enums/tipo_midia.dart';

class MidiaEntity {
  final String id;
  final String mediableType;
  final String mediableId;
  final String storagePath;
  final String mimeType;
  final TipoMidia tipo;
  final String url;
  final String? descricao;

  const MidiaEntity({
    required this.id,
    required this.mediableType,
    required this.mediableId,
    required this.storagePath,
    required this.mimeType,
    required this.tipo,
    required this.url,
    this.descricao,
  });
}
