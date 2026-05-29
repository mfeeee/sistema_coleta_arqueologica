class PreferenciasNotificacao {
  const PreferenciasNotificacao({
    this.habilitarColeta = true,
    this.habilitarSync = true,
    this.habilitarSistema = true,
    this.habilitarNotificacoesPush = false,
  });

  final bool habilitarColeta;
  final bool habilitarSync;
  final bool habilitarSistema;
  final bool habilitarNotificacoesPush;

  Map<String, dynamic> toJson() => {
    'habilitar_coleta': habilitarColeta,
    'habilitar_sync': habilitarSync,
    'habilitar_sistema': habilitarSistema,
    'habilitar_push': habilitarNotificacoesPush,
  };

  factory PreferenciasNotificacao.fromJson(Map<String, dynamic> json) =>
      PreferenciasNotificacao(
        habilitarColeta: json['habilitar_coleta'] as bool? ?? true,
        habilitarSync: json['habilitar_sync'] as bool? ?? true,
        habilitarSistema: json['habilitar_sistema'] as bool? ?? true,
        habilitarNotificacoesPush: json['habilitar_push'] as bool? ?? false,
      );

  PreferenciasNotificacao copyWith({
    bool? habilitarColeta,
    bool? habilitarSync,
    bool? habilitarSistema,
    bool? habilitarNotificacoesPush,
  }) => PreferenciasNotificacao(
    habilitarColeta: habilitarColeta ?? this.habilitarColeta,
    habilitarSync: habilitarSync ?? this.habilitarSync,
    habilitarSistema: habilitarSistema ?? this.habilitarSistema,
    habilitarNotificacoesPush:
        habilitarNotificacoesPush ?? this.habilitarNotificacoesPush,
  );
}
