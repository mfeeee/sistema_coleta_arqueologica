import 'package:drift/drift.dart';
import 'bens_materiais_table.dart';

class ResponsaveisSitio extends Table {
  TextColumn get uuid => text()();

  TextColumn get bemMaterialId =>
      text().named('bem_material_id').references(BensMateriais, #uuid)();

  TextColumn get contatoNome => text().named('contato_nome')();
  TextColumn get contatoEmail => text().named('contato_email').nullable()();
  TextColumn get contatoTelefone =>
      text().named('contato_telefone').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {bemMaterialId},
  ];
}
