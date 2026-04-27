import 'dart:convert';
import 'package:drift/drift.dart';

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
