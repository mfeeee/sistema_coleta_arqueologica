class SyncResumo {
  final int sucessos;
  final int conflitos;
  final int erros;

  const SyncResumo({
    required this.sucessos,
    required this.conflitos,
    required this.erros,
  });

  bool get totalOk => conflitos == 0 && erros == 0;
  int get total => sucessos + conflitos + erros;
}

/// `recusada`: a API recusou a coleta (403 ou 422); reenviar igual não
/// adianta, o coletor precisa corrigir.
enum SyncResultStatus { sucesso, conflito, recusada, erroRede }
