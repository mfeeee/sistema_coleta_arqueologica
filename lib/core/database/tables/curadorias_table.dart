import 'package:drift/drift.dart';
import 'coletas_table.dart';
import 'bens_materiais_table.dart';
import 'usuarios_table.dart';
import '../enums/status_curadoria.dart';

@TableIndex(name: 'status', columns: {#status})
@TableIndex(name: 'curadorias_coleta_idx', columns: {#coletaId})
class Curadorias extends Table {
  TextColumn get uuid => text()();

  TextColumn get coletaId =>
      text().named('coleta_id').references(Coletas, #uuid)();

  TextColumn get bemMaterialId => text()
      .named('bem_material_id')
      .nullable()
      .references(BensMateriais, #uuid)();

  TextColumn get usuarioId =>
      text().named('usuario_id').references(Usuarios, #uuid)();

  TextColumn get status => textEnum<StatusCuradoria>()
      .named('status_curadoria')
      .clientDefault(() => StatusCuradoria.pendente.name)();

  TextColumn get acaoResultante => textEnum<AcaoResultanteCuradoria>()
      .named('acao_resultante')
      .clientDefault(() => AcaoResultanteCuradoria.criarSitio.name)();

  DateTimeColumn get dataAvaliacao =>
      dateTime().named('data_avaliacao').clientDefault(() => DateTime.now())();

  TextColumn get observacao => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}
