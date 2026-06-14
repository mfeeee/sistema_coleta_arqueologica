import 'dart:io';
import '../../../../core/models/midia_model.dart';
import '../repositories/midia_repository.dart';

class UploadMidiaUseCase {
  final MidiaRepository _repository;

  UploadMidiaUseCase(this._repository);

  Future<MidiaModel> call({
    required File file,
    required String mediableType,
    required String mediableId,
    required String tipo,
    String? descricao,
  }) {
    return _repository.uploadMidia(
      file: file,
      mediableType: mediableType,
      mediableId: mediableId,
      tipo: tipo,
      descricao: descricao,
    );
  }
}
