// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'midia_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MidiaModel _$MidiaModelFromJson(Map<String, dynamic> json) => MidiaModel(
  id: json['id'] as String,
  mediableType: json['mediable_type'] as String,
  mediableId: json['mediable_id'] as String,
  storagePath: json['storage_path'] as String,
  mimeType: json['mime_type'] as String,
  tipo: $enumDecode(_$TipoMidiaEnumMap, json['tipo']),
  url: json['url'] as String,
  descricao: json['descricao'] as String?,
);

Map<String, dynamic> _$MidiaModelToJson(MidiaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediable_type': instance.mediableType,
      'mediable_id': instance.mediableId,
      'storage_path': instance.storagePath,
      'mime_type': instance.mimeType,
      'tipo': _$TipoMidiaEnumMap[instance.tipo]!,
      'url': instance.url,
      'descricao': instance.descricao,
    };

const _$TipoMidiaEnumMap = {
  TipoMidia.imagem: 'imagem',
  TipoMidia.video: 'video',
  TipoMidia.tese: 'tese',
  TipoMidia.artigo: 'artigo',
};
