import 'package:json_annotation/json_annotation.dart';
import '../entities/localizacao_entity.dart';

part 'localizacao_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class LocalizacaoModel extends LocalizacaoEntity {
  const LocalizacaoModel({
    required super.id,
    super.cep,
    super.logradouro,
    super.municipio,
    super.uf,
    super.lat,
    super.lng,
  });

  @JsonKey(name: 'lat', readValue: readLat)
  @override
  double? get lat => super.lat;

  @JsonKey(name: 'lng', readValue: readLng)
  @override
  double? get lng => super.lng;

  static Object? readLat(Map json, String key) {
    if (json['lat'] != null) return json['lat'];
    final geom = json['geom'];
    if (geom is Map) return geom['lat'];
    if (geom is String && geom.startsWith('POINT')) {
      final match = RegExp(r'POINT\s?\((.*)\)').firstMatch(geom);
      if (match != null) {
        final coords = match.group(1)?.trim().split(' ');
        if (coords != null && coords.length >= 2) {
          return double.tryParse(coords[1]);
        }
      }
    }
    return null;
  }

  static Object? readLng(Map json, String key) {
    if (json['lng'] != null) return json['lng'];
    final geom = json['geom'];
    if (geom is Map) return geom['lng'];
    if (geom is String && geom.startsWith('POINT')) {
      final match = RegExp(r'POINT\s?\((.*)\)').firstMatch(geom);
      if (match != null) {
        final coords = match.group(1)?.trim().split(' ');
        if (coords != null && coords.length >= 2) {
          return double.tryParse(coords[0]);
        }
      }
    }
    return null;
  }

  factory LocalizacaoModel.fromJson(Map<String, dynamic> json) =>
      _$LocalizacaoModelFromJson(json);

  Map<String, dynamic> toJson() {
    final map = _$LocalizacaoModelToJson(this);
    if (lat != null || lng != null) {
      map['geom'] = {'lat': lat, 'lng': lng};
    }
    map.remove('lat');
    map.remove('lng');
    return map;
  }
}
