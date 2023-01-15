import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'diary_list.dart';
import 'diary_page.dart';
import 'diary_model.dart';
import 'calendar_view.dart';
import 'diary_drawer.dart';
import 'diary_database.dart';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({
    super.key,
    required this.title,
    required this.theme,
    required this.setTheme,
  });

  final String title;
  final bool theme;
  final void Function(bool) setTheme;

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  List<Diary> diaryEntries = [];
  int bottomItem = 0;

  // Function to set diary entries. Possible modes are append, delete and update.
  // Then it will sort the diary entries by createdDate and write it to disk.
  void addDiaryEntry(Diary newDiary) {
    // setState(() {
    //   diaryEntries.add(newDiary);
    //   // sort the entries by date of creation (in descending order)
    //   diaryEntries.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    // });
    // _writeDiaryEntries();
    insertDiaryEntry(newDiary);
    setState(() {

    });
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
  // TODO: Read/write from Sqlite db
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
    final jsonEntries =
    diaryEntries.map((diary) => Diary.toJSONString(diary)).toList();
    await prefs.setStringList("diaryEntries", jsonEntries);
  }

  @override
  void initState() {
    super.initState();
    // _readDiaryEntries();
  }

  @override
  void dispose() {
    // _writeDiaryEntries();
    super.dispose();
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      bottomItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Used future builder in the list of diary entries future returned by the database
    return FutureBuilder<List<Diary>>(
      future: getDiaryEntries(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),

            actions: <Widget>[
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
              // IconButton(onPressed: () {}, icon: const Icon(Icons.sell_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],
          ),

          drawer: DiaryDrawer(theme: widget.theme, setTheme: widget.setTheme),

          body: <Widget>[
            // Diary list view
            Center(
              child: snapshot.hasData
                  ? DiaryList(
                diaryEntries: snapshot.data ?? [],
                updateDiaryEntry: updateDiaryEntry,
                addDiaryEntry: addDiaryEntry,
                deleteDiaryEntry: deleteDiaryEntry,
              )
                  : const Text("No diary entries"),
            ),

            // Calendar view
            CalendarView(
              diaryEntries: snapshot.data ?? [],
              updateDiaryEntry: updateDiaryEntry,
              addDiaryEntry: addDiaryEntry,
              deleteDiaryEntry: deleteDiaryEntry,
            ),
          ].elementAt(bottomItem),

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
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "Diary"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Calendar"),
            ],
            onTap: _onBottomItemTapped,
            currentIndex: bottomItem,
          ),
        );
      },
    );
  }
}

