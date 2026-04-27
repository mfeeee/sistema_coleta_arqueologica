import 'package:drift/drift.dart';
import '../enums/perfil_usuario.dart';

class Usuarios extends Table {
  TextColumn get uuid => text()();

  TextColumn get nome => text().withLength(min: 1, max: 150)();

  TextColumn get email => text().unique()();

  TextColumn get senhaHash => text().named('senha_hash')();

  TextColumn get perfil => textEnum<PerfilUsuario>()
      .named('perfil_usuario')
      .clientDefault(() => PerfilUsuario.coletor.name)();

  TextColumn get classificacao => textEnum<ClassificacaoUsuario>()
      .named('classificacao')
      .clientDefault(() => ClassificacaoUsuario.arqueologo.name)();

  BoolColumn get ativo => boolean().clientDefault(() => true)();

  DateTimeColumn get criadoEm =>
      dateTime().named('criado_em').clientDefault(() => DateTime.now())();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
