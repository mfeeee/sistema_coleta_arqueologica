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

enum SyncResultStatus { sucesso, conflito, erroRede }
