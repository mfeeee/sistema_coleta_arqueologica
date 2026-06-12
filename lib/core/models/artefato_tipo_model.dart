import 'package:json_annotation/json_annotation.dart';
import '../entities/artefato_tipo_entity.dart';

part 'artefato_tipo_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ArtefatoTipoModel extends ArtefatoTipoEntity {
  const ArtefatoTipoModel({
    required super.id,
    required super.nome,
    super.descricaoNova,
    super.novoTipo = false,
  });

  factory ArtefatoTipoModel.fromJson(Map<String, dynamic> json) =>
      _$ArtefatoTipoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArtefatoTipoModelToJson(this);
}
