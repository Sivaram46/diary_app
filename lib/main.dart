import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'diary_list.dart';
import 'diary_page.dart';
import 'diary_model.dart';
import 'populate_diary_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DiaryHomePage(title: "Diary App")
    );

  }
}

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({super.key, required this.title});

  final String title;

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {

  List<Diary> diaryEntries = [];

  // Function to set diary entries. Possible modes are append, delete and update.
  // Then it will sort the diary entries by createdDate and write it to disk.
  void addDiaryEntry(Diary newDiary) {
    setState(() {
      diaryEntries.add(newDiary);
      // sort the entries by date of creation (in descending order)
      diaryEntries.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    });
    _writeDiaryEntries();
  }

  void updateDiaryEntry(Diary oldDiary, Diary newDiary) {
    setState(() {
      int index = diaryEntries.indexOf(oldDiary);
      if (index > 0) {
        diaryEntries[index].createdDate = newDiary.createdDate;
        diaryEntries[index].body = newDiary.body;
        diaryEntries[index].title = newDiary.title;
        diaryEntries[index].mood = newDiary.mood;
      }
      diaryEntries.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    });
    _writeDiaryEntries();
  }

  void deleteDiaryEntry(Diary toDelete) {
    setState(() {
      diaryEntries.remove(toDelete);
    });
    _writeDiaryEntries();
  }


  // Load SharedPreferences in homepage and load all (or some) list entries to the state.
  void _readDiaryEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonEntries = prefs.getStringList("diaryEntries");

    if (jsonEntries != null) {
      for (var jsonEntry in jsonEntries) {
        diaryEntries.add(Diary.fromJSON(jsonDecode(jsonEntry)));
      }
    }

    /*
    var tempJsonEntries = getDiaryData();
    await prefs.setStringList("diaryEntries", tempJsonEntries);
    for (var jsonEntry in tempJsonEntries) {
      diaryEntries.add(Diary.fromJSON(jsonDecode(jsonEntry)));
    }
    */

    // state is set-up up reflect the changes in diary entries
    setState(() {});
  }

  Future<void> _writeDiaryEntries() async {
    // converting list to json strings to write
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonEntries = diaryEntries.map((diary) => Diary.toJSONString(diary)).toList();
    await prefs.setStringList("diaryEntries", jsonEntries);
  }

  @override
  void initState() {
    super.initState();
    _readDiaryEntries();
  }

  @override
  void dispose() {
    // _writeDiaryEntries();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("length: ${diaryEntries.length}");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),

        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.sell_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      body: Center(
        child:
          diaryEntries.isNotEmpty
          ? DiaryList(
            diaryEntries: diaryEntries,
            updateDiaryEntry: updateDiaryEntry,
            addDiaryEntry: addDiaryEntry,
            deleteDiaryEntry: deleteDiaryEntry,
          ) :
          const Text("No diary entries"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiaryPage(
                updateDiaryEntry: updateDiaryEntry,
                addDiaryEntry: addDiaryEntry,
                deleteDiaryEntry: deleteDiaryEntry,
                isEdit: true,
              ),
            ),
          );
        },
        tooltip: 'Add diary entry',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Calendar"
          ),
        ],
      ),
    );
  }
}
