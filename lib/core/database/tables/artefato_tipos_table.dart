import 'package:drift/drift.dart';

class ArtefatoTipos extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  BoolColumn get novoTipo => boolean().withDefault(const Constant(false))();
  BoolColumn get sincronizado => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
