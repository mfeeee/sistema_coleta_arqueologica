import 'package:drift/drift.dart';
import 'bens_materiais_table.dart';
import '../enums/tipo_midia.dart';

class MidiaLinks extends Table {
  TextColumn get uuid => text()();

  TextColumn get bemMaterialId =>
      text().named('bem_material_id').references(BensMateriais, #uuid)();

  TextColumn get tipo => textEnum<TipoMidia>()
      .named('tipo')
      .clientDefault(() => TipoMidia.imagem.name)();

  TextColumn get url => text()();

  TextColumn get descricao => text().named('descricao').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
