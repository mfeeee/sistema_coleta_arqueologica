import '../../domain/entities/sitio_cache_entity.dart';

class SitioCacheModel extends SitioCacheEntity {
  const SitioCacheModel({
    required super.id,
    required super.nome,
    required super.latitude,
    required super.longitude,
  });

  factory SitioCacheModel.fromMap(Map<String, dynamic> map) {
    return SitioCacheModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['latitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SitioCacheModel.fromJson(Map<String, dynamic> json) {
    return SitioCacheModel.fromMap(json);
  }
}
