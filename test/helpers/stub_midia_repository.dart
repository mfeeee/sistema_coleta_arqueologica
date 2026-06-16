import 'dart:io';
import 'package:sistema_coleta_arqueologica/core/models/midia_model.dart';
import 'package:sistema_coleta_arqueologica/features/media/domain/repositories/midia_repository.dart';
import 'package:sistema_coleta_arqueologica/features/media/domain/usecases/upload_midia_usecase.dart';
import 'package:sistema_coleta_arqueologica/core/database/enums/tipo_midia.dart';

class StubMidiaRepository implements MidiaRepository {
  @override
  Future<MidiaModel> uploadMidia({
    required File file,
    required String mediableType,
    required String mediableId,
    required String tipo,
    String? descricao,
  }) async {
    return MidiaModel(
      id: 'stub_id',
      mediableType: mediableType,
      mediableId: mediableId,
      storagePath: 'stub_path.jpg',
      mimeType: 'image/jpeg',
      tipo: TipoMidia.imagem,
      url: 'http://example.com/stub.jpg',
    );
  }
}

class StubUploadMidiaUseCase extends UploadMidiaUseCase {
  StubUploadMidiaUseCase() : super(StubMidiaRepository());
}
