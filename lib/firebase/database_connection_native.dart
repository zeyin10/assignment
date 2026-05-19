import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<QueryExecutor> openConnection() async {
  final dir  = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'yummy.sqlite');
  return NativeDatabase.createInBackground(File(path));
}