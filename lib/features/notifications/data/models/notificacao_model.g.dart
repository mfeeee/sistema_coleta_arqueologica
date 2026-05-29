// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificacaoModel _$NotificacaoModelFromJson(Map<String, dynamic> json) =>
    NotificacaoModel(
      id: (json['id'] as num).toInt(),
      titulo: json['title'] as String,
      mensagem: json['body'] as String,
      tipo: json['type'] as String,
      lida: json['is_read'] as bool,
      criadaEm: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificacaoModelToJson(NotificacaoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.titulo,
      'body': instance.mensagem,
      'type': instance.tipo,
      'is_read': instance.lida,
      'created_at': instance.criadaEm.toIso8601String(),
    };
