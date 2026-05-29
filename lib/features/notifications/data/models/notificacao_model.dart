import 'package:json_annotation/json_annotation.dart';

part 'notificacao_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificacaoModel {
  const NotificacaoModel({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.tipo,
    required this.lida,
    required this.criadaEm,
  });

  final int id;

  @JsonKey(name: 'title')
  final String titulo;

  @JsonKey(name: 'body')
  final String mensagem;

  @JsonKey(name: 'type')
  final String tipo;

  @JsonKey(name: 'is_read')
  final bool lida;

  @JsonKey(name: 'created_at')
  final DateTime criadaEm;

  factory NotificacaoModel.fromJson(Map<String, dynamic> json) =>
      _$NotificacaoModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificacaoModelToJson(this);

  NotificacaoModel marcarComoLida() => NotificacaoModel(
    id: id,
    titulo: titulo,
    mensagem: mensagem,
    tipo: tipo,
    lida: true,
    criadaEm: criadaEm,
  );
}
