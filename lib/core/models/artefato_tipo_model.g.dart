// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artefato_tipo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtefatoTipoModel _$ArtefatoTipoModelFromJson(Map<String, dynamic> json) =>
    ArtefatoTipoModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descricaoNova: json['descricao_nova'] as String?,
      novoTipo: json['novo_tipo'] as bool? ?? false,
    );

Map<String, dynamic> _$ArtefatoTipoModelToJson(ArtefatoTipoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao_nova': instance.descricaoNova,
      'novo_tipo': instance.novoTipo,
    };
