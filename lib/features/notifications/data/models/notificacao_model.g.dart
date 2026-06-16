// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificacaoModel _$NotificacaoModelFromJson(Map<String, dynamic> json) =>
    NotificacaoModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      corpo: json['corpo'] as String,
      tipo: json['tipo'] as String,
      lida: json['lida'] as bool,
      lidaEm: json['lida_em'] == null
          ? null
          : DateTime.parse(json['lida_em'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificacaoModelToJson(NotificacaoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'corpo': instance.corpo,
      'tipo': instance.tipo,
      'lida': instance.lida,
      'lida_em': instance.lidaEm?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

PreferenciasNotificacaoModel _$PreferenciasNotificacaoModelFromJson(
  Map<String, dynamic> json,
) => PreferenciasNotificacaoModel(
  coleta: json['coleta'] as bool,
  sync: json['sync'] as bool,
  sistema: json['sistema'] as bool,
  push: json['push'] as bool,
);

Map<String, dynamic> _$PreferenciasNotificacaoModelToJson(
  PreferenciasNotificacaoModel instance,
) => <String, dynamic>{
  'coleta': instance.coleta,
  'sync': instance.sync,
  'sistema': instance.sistema,
  'push': instance.push,
};
