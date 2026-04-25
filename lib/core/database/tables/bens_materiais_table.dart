import 'package:drift/drift.dart';
import 'coletas_table.dart';

@TableIndex(name: 'bens_coleta_idx', columns: {#coletaId})
@TableIndex(name: 'municipio', columns: {#municipio})
class BensMateriais extends Table {
  TextColumn get uuid => text()();

  TextColumn get coletaId =>
      text().named('coleta_id').references(Coletas, #uuid)();

  TextColumn get codigoIphan => text().named('codigo_iphan').nullable()();
  TextColumn get nomeBem => text().named('nome_bem')();
  TextColumn get nomesPopulares => text().named('nomes_populares').nullable()();
  TextColumn get natureza => text()();
  TextColumn get tipo => text()();
  TextColumn get meiosAcesso => text().named('meios_acesso').nullable()();
  BoolColumn get publicado => boolean().clientDefault(() => false)();
  TextColumn get uf => text().withLength(min: 2, max: 2)();
  TextColumn get municipio => text()();
  TextColumn get cep => text().nullable()();
  TextColumn get endereco => text().nullable()();
  TextColumn get latitude => text().nullable()();
  TextColumn get longitude => text().nullable()();
  TextColumn get geojson => text().nullable()();
  DateTimeColumn get criadoEm =>
      dateTime().named('criado_em').clientDefault(() => DateTime.now())();
  DateTimeColumn get atualizadoEm =>
      dateTime().named('atualizado_em').clientDefault(() => DateTime.now())();
  DateTimeColumn get deletadoEm => dateTime().named('deletado_em').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
