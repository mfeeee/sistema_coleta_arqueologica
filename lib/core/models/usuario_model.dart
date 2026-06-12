import 'package:json_annotation/json_annotation.dart';
import '../entities/usuario_entity.dart';

part 'usuario_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    @JsonKey(name: 'name') required super.nome,
    super.email,
    super.avatarUrl,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioModelToJson(this);
}
