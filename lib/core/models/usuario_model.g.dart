// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioModel _$UsuarioModelFromJson(Map<String, dynamic> json) => UsuarioModel(
  id: json['id'] as String,
  nome: json['name'] as String,
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$UsuarioModelToJson(UsuarioModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.nome,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
    };
