// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bem_responsavel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BemResponsavelModel _$BemResponsavelModelFromJson(Map<String, dynamic> json) =>
    BemResponsavelModel(
      usuarioModel: UsuarioModel.fromJson(json['user'] as Map<String, dynamic>),
      papel: json['papel'] as String,
    );

Map<String, dynamic> _$BemResponsavelModelToJson(
  BemResponsavelModel instance,
) => <String, dynamic>{
  'papel': instance.papel,
  'user': instance.usuarioModel.toJson(),
};
