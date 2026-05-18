import 'dart:developer' as developer;

class LogCapture {
  LogCapture._();

  static final List<String> _entradas = [];
  static const int _capacidadeMaxima = 200;

  static void registrar(
    String mensagem, {
    String? nome,
    Object? erro,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final linha =
        '[$timestamp] ${nome ?? 'App'}: $mensagem'
        '${erro != null ? '\n  Erro: $erro' : ''}';
    _entradas.add(linha);
    if (_entradas.length > _capacidadeMaxima) _entradas.removeAt(0);
    developer.log(
      mensagem,
      name: nome ?? 'App',
      error: erro,
      stackTrace: stackTrace,
    );
  }

  static List<String> obterEntradas() => List.unmodifiable(_entradas);
}
