import 'dart:developer';
import 'package:dio/dio.dart';

Future<T> comRetry<T>({
  required Future<T> Function() operacao,
  int maxTentativas = 3,
  Duration delayInicial = const Duration(seconds: 1),
  void Function(int tentativaAtual, int max)? onTentativa,
}) async {
  Duration delay = delayInicial;

  for (int tentativa = 1; tentativa <= maxTentativas; tentativa++) {
    try {
      return await operacao();
    } on DioException catch (e, st) {
      final ultima = tentativa == maxTentativas;

      if (!_ehTransitorio(e) || ultima) {
        log(
          'comRetry: falha definitiva na tentativa $tentativa/$maxTentativas.',
          error: e,
          stackTrace: st,
          name: 'RetryUtil',
        );
        rethrow;
      }

      log(
        'comRetry: erro transitório na tentativa $tentativa/$maxTentativas. '
        'Aguardando ${delay.inSeconds}s…',
        name: 'RetryUtil',
      );
      await Future.delayed(delay);
      delay *= 2;
      onTentativa?.call(tentativa + 1, maxTentativas);
    }
  }

  throw StateError('comRetry: estado inalcançável');
}

bool _ehTransitorio(DioException e) =>
    e.type == DioExceptionType.connectionTimeout ||
    e.type == DioExceptionType.receiveTimeout ||
    e.type == DioExceptionType.connectionError ||
    (e.response?.statusCode ?? 0) >= 500;
