import 'package:json_annotation/json_annotation.dart';
import '../entities/midia_entity.dart';
import '../database/enums/tipo_midia.dart';

part 'midia_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MidiaModel extends MidiaEntity {
  const MidiaModel({
    required super.id,
    required super.mediableType,
    required super.mediableId,
    required super.storagePath,
    required super.mimeType,
    required super.tipo,
    required super.url,
    super.descricao,
  });

  factory MidiaModel.fromJson(Map<String, dynamic> json) =>
      _$MidiaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MidiaModelToJson(this);
}
