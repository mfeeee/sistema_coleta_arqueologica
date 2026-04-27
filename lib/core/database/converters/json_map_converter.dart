import 'dart:convert';
import 'package:drift/drift.dart';

class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const JsonMapConverter();

  @override
  Map<String, Object?> fromSql(String fromDb) {
    try {
      return jsonDecode(fromDb) as Map<String, Object?>;
    } catch (_) {
      return {};
    }
  }

  @override
  String toSql(Map<String, Object?> value) => jsonEncode(value);
}