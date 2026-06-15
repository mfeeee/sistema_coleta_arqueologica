import 'package:json_annotation/json_annotation.dart';

part 'notificacao_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificacaoModel {
  const NotificacaoModel({
    required this.id,
    required this.titulo,
    required this.corpo,
    required this.tipo,
    required this.lida,
    this.lidaEm,
    required this.createdAt,
  });

  final String id;
  final String titulo;
  final String corpo;
  final String tipo;
  final bool lida;
  final DateTime? lidaEm;
  final DateTime createdAt;

  factory NotificacaoModel.fromJson(Map<String, dynamic> json) =>
      _$NotificacaoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificacaoModelToJson(this);

  NotificacaoModel copyWith({
    String? id,
    String? titulo,
    String? corpo,
    String? tipo,
    bool? lida,
    DateTime? lidaEm,
    DateTime? createdAt,
  }) {
    return NotificacaoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      corpo: corpo ?? this.corpo,
      tipo: tipo ?? this.tipo,
      lida: lida ?? this.lida,
      lidaEm: lidaEm ?? this.lidaEm,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PreferenciasNotificacaoModel {
  const PreferenciasNotificacaoModel({
    required this.pushEnabled,
    required this.emailEnabled,
    required this.tiposHabilitados,
  });

  final bool pushEnabled;
  final bool emailEnabled;
  final List<String> tiposHabilitados;

  factory PreferenciasNotificacaoModel.fromJson(Map<String, dynamic> json) =>
      _$PreferenciasNotificacaoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreferenciasNotificacaoModelToJson(this);

  PreferenciasNotificacaoModel copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    List<String>? tiposHabilitados,
  }) {
    return PreferenciasNotificacaoModel(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      tiposHabilitados: tiposHabilitados ?? this.tiposHabilitados,
    );
  }
}
