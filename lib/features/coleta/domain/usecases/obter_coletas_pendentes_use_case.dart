import '../entities/coleta_entity.dart';
import '../repositories/coleta_repository.dart';

class ObterColetasPendentesUseCase {
  const ObterColetasPendentesUseCase(this._repository);

  final ColetaRepository _repository;

  Future<List<ColetaEntity>> call() => _repository.getPendentes();
}
