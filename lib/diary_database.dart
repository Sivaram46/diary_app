import 'dart:io';

import 'package:flutter/material.dart';
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
        'diary_entries',
        sampleDiary.toMap()
      );
      // await db.execute(
      //   """
      //   INSERT INTO diary_entries(
      //     title, body, created_date, mood
      //   ) VALUES(
      //     'Sample diary entry', 'This is just a sample entry created', '2023-01-01 00:00:00.000', 'Happy'
      //   )
      //   """
      // );
    }
  );

  return database;
}

Future<void> insertDiaryEntry(Diary diaryEntry) async {
  Database db = await createDatabase();
  await db.insert('diary_entries', diaryEntry.toMap());
  db.close();
}

Future<List<Diary>> getDiaryEntries() async {
  Database db = await createDatabase();
  List<Map<String, dynamic>> rows = await db.query('diary_entries');
  List<Diary> entries = rows.map((row) => Diary.fromJSON(row)).toList();
  db.close();

  return entries;
}
