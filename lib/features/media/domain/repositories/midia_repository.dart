import 'dart:io';
import '../../../../core/models/midia_model.dart';

abstract class MidiaRepository {
  Future<MidiaModel> uploadMidia({
    required File file,
    required String mediableType,
    required String mediableId,
    required String tipo,
    String? descricao,
  });
}
