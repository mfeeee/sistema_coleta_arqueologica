import 'package:json_annotation/json_annotation.dart';
import 'package:sistema_coleta_arqueologica/core/models/usuario_model.dart';
import 'package:sistema_coleta_arqueologica/features/bem_material/domain/entities/bem_responsavel_entity.dart';

part 'bem_responsavel_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BemResponsavelModel extends BemResponsavelEntity {
  @JsonKey(name: 'user')
  final UsuarioModel usuarioModel;

  BemResponsavelModel({required this.usuarioModel, required super.papel})
    : super(usuario: usuarioModel);

  factory BemResponsavelModel.fromJson(Map<String, dynamic> json) =>
      _$BemResponsavelModelFromJson(json);

  Map<String, dynamic> toJson() => _$BemResponsavelModelToJson(this);
}
