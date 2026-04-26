import 'package:drift/drift.dart';
import 'usuarios_table.dart';
import '../converters/json_map_converters.dart';
import '../enums/enum_converters.dart';

class StatusColetaConverter extends TypeConverter<StatusColeta, String> {
  const StatusColetaConverter();

  @override
  StatusColeta fromSql(String fromDb) =>
      StatusColeta.values.byName(fromDb);

  @override
  String toSql(StatusColeta value) => value.name;
}

@TableIndex(name: 'coletas_usuario_idx', columns: {#usuarioId})
@TableIndex(name: 'coletas_sincronizada_idx', columns: {#statusSincronizacao})
class Coletas extends Table {
  TextColumn get uuid => text()();

  TextColumn get usuarioId =>
      text().named('usuario_id').references(Usuarios, #uuid)();

  DateTimeColumn get dataColeta =>
      dateTime().named('data_coleta').clientDefault(() => DateTime.now())();

  TextColumn get statusSincronizacao => text()
      .named('status_sincronizacao')
      .map(const StatusColetaConverter())
      .clientDefault(() => StatusColeta.pendente.name)();

  IntColumn get versao => integer().clientDefault(() => 1)();

  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').clientDefault(() => DateTime.now())();

  TextColumn get dadosColetados =>
      text().named('dados_coletados').map(const JsonMapConverter())();

  DateTimeColumn get deletadoEm => dateTime().named('deletado_em').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
