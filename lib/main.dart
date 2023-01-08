import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_app_lock/flutter_app_lock.dart';

import 'diary_list.dart';
import 'diary_page.dart';
import 'diary_model.dart';
import 'calendar_view.dart';
import 'diary_drawer.dart';
import 'lock_screen.dart';
import 'populate_diary_data.dart';

// TODO: Bug - Read from shared prefs not working
void readPasswordPrefs(
  void Function(bool) setPasswordStatus,
  void Function(String) setPassword
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool("passwordStatus") ?? false;
  String pwd = prefs.getString("password") ?? "";
  setPasswordStatus(status);
  setPassword(pwd);
}

void main({
  Duration backgroundLockLatency = const Duration(seconds: 1),
}) {
  // Set default password status and password
  String password = "0000";
  bool enabled = true;
  void setPasswordStatus(bool status) { enabled = status; }
  void setPassword(String pwd) { password = pwd; }
  // Read it from disk
  readPasswordPrefs(setPasswordStatus, setPassword);

  runApp(AppLock(
    builder: (arg) => const MyApp(
      key: Key('MyApp'),
    ),
    lockScreen: LockScreen(
      key: const Key('LockScreen'),
      password: password,
    ),
    enabled: enabled,
    backgroundLockLatency: backgroundLockLatency,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool _isDark = true;

  void setTheme(bool mode) {
    setState(() {
      _isDark = mode;
    });
  }

  void readTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool theme = prefs.getBool('theme') ?? true;
    setTheme(theme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Diary App',
        theme: _isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
        home: DiaryHomePage(
          title: "Diary App",
          theme: _isDark,
          setTheme: setTheme,
        ),
    );
  }
}

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
    _readDiaryEntries();
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
    // print("length: ${diaryEntries.length}");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
          child: diaryEntries.isNotEmpty
              ? DiaryList(
                  diaryEntries: diaryEntries,
                  updateDiaryEntry: updateDiaryEntry,
                  addDiaryEntry: addDiaryEntry,
                  deleteDiaryEntry: deleteDiaryEntry,
                )
              : const Text("No diary entries"),
        ),

        // Calendar view
        CalendarView(
          diaryEntries: diaryEntries,
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
  }
}
