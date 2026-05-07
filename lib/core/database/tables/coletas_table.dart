import 'package:drift/drift.dart';
import '../converters/json_map_converter.dart';
import '../enums/status_coleta.dart';
import 'dart:convert';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    try {
      return (jsonDecode(fromDb) as List).map((e) => e as String).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

@TableIndex(name: 'coletas_usuario_idx', columns: {#usuarioId})
@TableIndex(name: 'coletas_sincronizada_idx', columns: {#statusSincronizacao})
@TableIndex(name: 'coletas_natureza_idx', columns: {#natureza})
@TableIndex(name: 'coletas_uf_idx', columns: {#uf})
class Coletas extends Table {
  TextColumn get uuid => text()();

  TextColumn get usuarioId => text().named('usuario_id')();

  DateTimeColumn get dataColeta =>
      dateTime().named('data_coleta').clientDefault(() => DateTime.now())();

  TextColumn get statusSincronizacao => text()
      .named('status_sincronizacao')
      .map(const StatusColetaConverter())
      .clientDefault(() => StatusColeta.pendente.name)();

  TextColumn get nomeBem => text().named('nome_bem').clientDefault(() => '')();

  TextColumn get natureza => text().nullable()();

  TextColumn get tipo => text().nullable()();

  TextColumn get uf => text().withLength(min: 2, max: 2).nullable()();

  RealColumn get latitude => real().clientDefault(() => 0.0)();

  RealColumn get longitude => real().clientDefault(() => 0.0)();

  TextColumn get artefatos => text()
      .named('artefatos')
      .map(const StringListConverter())
      .clientDefault(() => '[]')();

  IntColumn get versao => integer().clientDefault(() => 1)();

  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').clientDefault(() => DateTime.now())();

  TextColumn get dadosColetados =>
      text().named('dados_coletados').map(const JsonMapConverter())();

  DateTimeColumn get deletadoEm => dateTime().named('deletado_em').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
