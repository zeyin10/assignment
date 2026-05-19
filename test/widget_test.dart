import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/main.dart';
import 'package:yummy/firebase/local_database.dart';
import 'package:yummy/firebase/database_connection.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final db = AppDatabase(await openConnection());
    await tester.pumpWidget(CinemaScope(db: db));
  });
}