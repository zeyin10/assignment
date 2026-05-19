import 'package:drift/drift.dart';

// This file is intentionally minimal — the real implementations are in
// database_connection_native.dart and database_connection_web.dart,
// selected by the conditional imports below.

export 'database_connection_native.dart'
if (dart.library.html) 'database_connection_web.dart';