import 'package:dio/dio.dart';

import '../../domain/repositories/coleta_repository.dart';
import '../models/coleta_model.dart';

/// Segundo passo do coletor: sincronizar só guarda a coleta no servidor;
/// enviar a coloca na fila de curadoria. Depois disso ela não pode mais ser
/// editada.
class EnvioCuradoriaService {
  const EnvioCuradoriaService({
    required this.dio,
    required this.coletaRepository,
  });

  final Dio dio;
  final ColetaRepository coletaRepository;

  /// Retorna `null` quando deu certo, ou a mensagem com que a API recusou
  /// (por exemplo, coleta já enviada). Sem conexão, lança a [DioException].
  Future<String?> enviar(String coletaId) async {
    try {
      final response = await dio.post(
        '/v1/mobile/coletas/$coletaId/enviar-curadoria',
      );
      final corpo = response.data as Map<String, dynamic>;
      final dados = corpo['data'] as Map<String, dynamic>;
      // A resposta traz a curadoria pendente: o app passa a mostrar a coleta
      // como enviada e esconde a edição.
      await coletaRepository.salvar(ColetaModel.fromJson(dados));
      return null;
    } on DioException catch (e) {
      final corpo = e.response?.data;
      final mensagem = corpo is Map ? corpo['message'] : null;
      if (e.response != null && mensagem is String) return mensagem;
      rethrow;
    }
  }
}
