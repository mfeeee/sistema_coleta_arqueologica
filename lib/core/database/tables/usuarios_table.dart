import 'package:drift/drift.dart';

class Usuarios extends Table {
  TextColumn get uuid => text()();

  TextColumn get nome => text().withLength(min: 1, max: 150)();

  TextColumn get email => text().unique()();

  TextColumn get senhaHash => text().named('senha_hash')();

  TextColumn get perfil => text()();

  TextColumn get classificacao => text()();

  BoolColumn get ativo => boolean().clientDefault(() => true)();

  DateTimeColumn get criadoEm =>
      dateTime().named('criado_em').clientDefault(() => DateTime.now())();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
