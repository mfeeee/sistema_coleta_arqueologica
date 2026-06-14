import 'dart:io';
import '../../../../core/models/midia_model.dart';
import '../../domain/repositories/midia_repository.dart';
import '../datasources/midia_remote_datasource.dart';

class MidiaRepositoryImpl implements MidiaRepository {
  final MidiaRemoteDatasource remoteDatasource;

  MidiaRepositoryImpl({required this.remoteDatasource});

  @override
  Future<MidiaModel> uploadMidia({
    required File file,
    required String mediableType,
    required String mediableId,
    required String tipo,
    String? descricao,
  }) {
    return remoteDatasource.uploadMidia(
      file: file,
      mediableType: mediableType,
      mediableId: mediableId,
      tipo: tipo,
      descricao: descricao,
    );
  }
}
