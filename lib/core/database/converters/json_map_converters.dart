import 'dart:convert';
import 'package:drift/drift.dart';

class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const JsonMapConverter();

  @override
  Map<String, Object?> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb);
    return Map<String, Object?>.from(decoded as Map);
  }

  @override
  String toSql(Map<String, Object?> value) {
    return jsonEncode(value);
  }
}
