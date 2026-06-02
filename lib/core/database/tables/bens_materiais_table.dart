import 'package:drift/drift.dart';
import '../converters/string_list_converter.dart';

@TableIndex(name: 'bens_coleta_idx', columns: {#coletaId})
@TableIndex(name: 'municipio', columns: {#municipio})
@TableIndex(name: 'bens_natureza_idx', columns: {#natureza})
@TableIndex(name: 'bens_tipo_idx', columns: {#tipo})
@TableIndex(name: 'bens_uf_idx', columns: {#uf})
class BensMateriais extends Table {
  TextColumn get uuid => text()();

  // Bens públicos não têm coleta associada; FK removida para permitir null.
  TextColumn get coletaId => text().named('coleta_id').nullable()();
  TextColumn get curadorResponsavelId =>
      text().named('curador_responsavel_id').nullable()();

  TextColumn get codigoIphan => text().named('codigo_iphan').nullable()();
  TextColumn get nomeBem => text().named('nome_bem')();
  TextColumn get nomesPopulares => text().named('nomes_populares').nullable()();
  TextColumn get natureza => text().nullable()();
  TextColumn get tipo => text().nullable()();
  TextColumn get meiosAcesso => text().named('meios_acesso').nullable()();
  TextColumn get artefatos => text()
      .named('artefatos')
      .map(const StringListConverter())
      .clientDefault(() => '[]')();
  BoolColumn get publicado => boolean().clientDefault(() => false)();
  TextColumn get uf => text().withLength(min: 2, max: 2).nullable()();
  TextColumn get municipio => text().nullable()();
  TextColumn get cep => text().nullable()();
  TextColumn get endereco => text().nullable()();
  // TEXT preserva decimal(10,7) exato; REAL seria float32 (~10m de erro).
  TextColumn get latitude => text().named('latitude').nullable()();
  TextColumn get longitude => text().named('longitude').nullable()();
  TextColumn get geojson => text().nullable()();
  IntColumn get anoRegistro => integer().named('ano_registro').nullable()();
  TextColumn get descricaoAtualizacao =>
      text().named('descricao_atualizacao').nullable()();
  DateTimeColumn get criadoEm =>
      dateTime().named('criado_em').clientDefault(() => DateTime.now())();
  DateTimeColumn get atualizadoEm =>
      dateTime().named('atualizado_em').clientDefault(() => DateTime.now())();
  DateTimeColumn get deletadoEm => dateTime().named('deletado_em').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
