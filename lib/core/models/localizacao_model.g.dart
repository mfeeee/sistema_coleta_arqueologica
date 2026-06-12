// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localizacao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalizacaoModel _$LocalizacaoModelFromJson(Map<String, dynamic> json) =>
    LocalizacaoModel(
      id: json['id'] as String,
      cep: json['cep'] as String?,
      logradouro: json['logradouro'] as String?,
      municipio: json['municipio'] as String?,
      uf: json['uf'] as String?,
      lat: (LocalizacaoModel.readLat(json, 'lat') as num?)?.toDouble(),
      lng: (LocalizacaoModel.readLng(json, 'lng') as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocalizacaoModelToJson(LocalizacaoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cep': instance.cep,
      'logradouro': instance.logradouro,
      'municipio': instance.municipio,
      'uf': instance.uf,
      'lat': instance.lat,
      'lng': instance.lng,
    };
