import 'package:drift/drift.dart';

enum StatusColeta {
  pendente,
  sincronizado,
  conflito;

  static StatusColeta fromString(String value) => StatusColeta.values
      .firstWhere((e) => e.name == value, orElse: () => StatusColeta.pendente);
}

class StatusColetaConverter extends TypeConverter<StatusColeta, String> {
  const StatusColetaConverter();

  @override
  StatusColeta fromSql(String fromDb) => StatusColeta.values.byName(fromDb);

  @override
  String toSql(StatusColeta value) => value.name;
}
