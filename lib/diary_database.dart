import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'diary_model.dart';

Future<Database> createDatabase() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = "${directory.path}/diary_entries.db";

  // final file = File(path);
  // await file.delete();

  Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        """
        CREATE TABLE diary_entries(
          id INTEGER PRIMARY KEY,
          title TEXT,
          body TEXT,
          created_date DATETIME,
          mood TEXT
        )
        """
      );
      final sampleDiary = Diary(
        createdDate: DateTime(2023, 1, 1),
        title: "Sample diary entry",
        body: "This is just a sample entry created",
        mood: "Happy"
      );
      // create a sample data
      await db.insert(
        "diary_entries",
        sampleDiary.toMap()
      );
    }
  );

  return database;
}

Future<void> insertDiaryIntoDB(Diary diaryEntry) async {
  Database db = await createDatabase();
  await db.insert("diary_entries", diaryEntry.toMap());
  db.close();
}


Future<void> updateDiaryDB(Diary diaryEntry) async {
  Database db = await createDatabase();
  await db.update(
    "diary_entries",
    diaryEntry.toMap(),
    where: "id = ?",
    whereArgs: [diaryEntry.id]
  );
  db.close();
}

Future<void> removeDiaryFromDB(int id) async {
  Database db = await createDatabase();
  await db.delete(
    "diary_entries",
    where: "id = ?",
    whereArgs: [id]
  );
  db.close();
}

Future<List<Diary>> getDiariesFromDB() async {
  Database db = await createDatabase();
  List<Map<String, dynamic>> rows = await db.query(
    "diary_entries",
    orderBy: "created_date DESC",
  );
  List<Diary> entries = rows.map((row) => Diary.fromJSON(row)).toList();
  db.close();

  return entries;
}
