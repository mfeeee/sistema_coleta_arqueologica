import 'package:drift/drift.dart';
import 'usuarios_table.dart';
import 'curadorias_table.dart';
import '../converters/json_map_converters.dart';

@TableIndex(name: 'auditorias_usuario_idx', columns: {#usuarioId})
@TableIndex(name: 'entidade_tipo', columns: {#entidadeTipo})
@TableIndex(name: 'entidade_id', columns: {#entidadeId})
class Auditorias extends Table {
  TextColumn get uuid => text()();

  TextColumn get usuarioId =>
      text().named('usuario_id').references(Usuarios, #uuid)();

  TextColumn get entidadeTipo => text().named('entidade_tipo')();
  TextColumn get entidadeId => text().named('entidade_id')();
  TextColumn get curadoriaId =>
      text().named('curadoria_id').nullable().references(Curadorias, #uuid)();

  TextColumn get operacao => text()();
  TextColumn get meio => text()();
  DateTimeColumn get dataHora =>
      dateTime().named('data_hora').clientDefault(() => DateTime.now())();

  TextColumn get valorAnterior =>
      text().named('valor_anterior').nullable().map(const JsonMapConverter())();

  TextColumn get valorNovo =>
      text().named('valor_novo').nullable().map(const JsonMapConverter())();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
