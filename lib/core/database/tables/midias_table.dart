import 'package:drift/drift.dart';
import '../enums/tipo_midia.dart';

class Midias extends Table {
  TextColumn get id => text()();
  TextColumn get mediableType => text().named('mediable_type')();
  TextColumn get mediableId => text().named('mediable_id')();
  TextColumn get storagePath => text().named('storage_path')();
  TextColumn get mimeType => text().named('mime_type')();
  TextColumn get tipo => textEnum<TipoMidia>().named('tipo')();
  TextColumn get url => text()();
  TextColumn get descricao => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
