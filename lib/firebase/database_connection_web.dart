import 'package:drift/drift.dart';
import 'package:drift/web.dart';

Future<QueryExecutor> openConnection() async {
  return WebDatabase('yummy_db');
}