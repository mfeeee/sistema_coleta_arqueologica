import 'package:drift/drift.dart';
import 'usuarios_table.dart';
import '../converters/json_map_converters.dart';

@TableIndex(name: 'coletas_usuario_idx', columns: {#usuarioId})
@TableIndex(name: 'coletas_sincronizada_idx', columns: {#sincronizada})
class Coletas extends Table {
  TextColumn get uuid => text()();

  TextColumn get usuarioId =>
      text().named('usuario_id').references(Usuarios, #uuid)();

  DateTimeColumn get dataColeta =>
      dateTime().named('data_coleta').clientDefault(() => DateTime.now())();

  BoolColumn get sincronizada => boolean().clientDefault(() => false)();

  TextColumn get dadosColetados =>
      text().named('dados_coletados').map(const JsonMapConverter())();

  DateTimeColumn get deletadoEm => dateTime().named('deletado_em').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
