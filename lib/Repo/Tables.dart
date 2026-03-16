import 'package:drift/drift.dart';

class Subjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subjectName => text()();
  IntColumn get classes => integer()();
  IntColumn get report => integer()();
  IntColumn get unit => integer()();
}
