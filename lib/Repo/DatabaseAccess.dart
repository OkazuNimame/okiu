import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okiu/Logic/SubjectData/GetSubjectData.dart';
import 'package:okiu/Repo/subject_database.dart';

class Databaseaccess {
  Future<List<Getsubjectdata>> getData() async {
    final db = await AppDatabase.instance.database;

    final data = await db.query("users");

    return data
        .map((m) => Getsubjectdata.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  void insertData(Map<String, dynamic> setData) async {
    final db = await AppDatabase.instance.database;
    await db.insert("users", setData);
  }

  void updeteData(int id, Map<String, dynamic> data) async {
    final db = await AppDatabase.instance.database;

    await db.update("users", data, where: "id = ?", whereArgs: [id]);
  }

  void deleteData(int id) async {
    final db = await AppDatabase.instance.database;

    await db.delete("users", where: "id = ?", whereArgs: [id]);
  }

  void updateDate(int id, String date) async {
    final db = await AppDatabase.instance.database;

    await db.update("users", {"date": date}, where: "id = ?", whereArgs: [id]);
  }

  void subDatabaseInsert(Map<String, dynamic> data) async {
    final db = await AppDatabase.instance.database;

    await db.insert("texts", data);
  }

  Future<List<SubDatabaseLogic>> getSubData(int id) async {
    final db = await AppDatabase.instance.database;

    final data = await db.query(
      "texts",
      where: "subject_id = ?",
      whereArgs: [id],
    );


    return data
        .map((m) => SubDatabaseLogic.fromMap(m))
        .toList();
  }

  void updateSubData(int id, int class_index, int data) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      "texts",
      {"checks": data},
      where: "id = ? AND class_index = ?",
      whereArgs: [id, class_index],
    );
  }

  void deleteSubData(int id) async {
    final db = await AppDatabase.instance.database;

    await db.delete("texts", where: "id = ?", whereArgs: [id]);
  }

  void deleteClassCheck(int id, int classIndex) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      "texts",
      {"date": "", "checks": 0, "text": ""},
      where: "id = ? AND class_index = ?",
      whereArgs: [id, classIndex],
    );
  }

  void deleteReportCheck(int id, int reportIndex) async {
    final db = await AppDatabase.instance.database;
  }
}

final databaseAccessProvider = Provider((ref) => Databaseaccess());

final subDatabaseProvider = FutureProvider.family<List<SubDatabaseLogic>,int>((
  ref,
  param,
) async{
  final database = ref.watch(databaseAccessProvider);

  return await database.getSubData(param);
});
final usersProvider = FutureProvider<List<Getsubjectdata>>((ref) async {
  final db = ref.watch(databaseAccessProvider);
  return db.getData();
});
