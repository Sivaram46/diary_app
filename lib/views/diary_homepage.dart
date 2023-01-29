import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'diary_list.dart';
import 'diary_page.dart';
import 'calendar_view.dart';
import 'diary_drawer.dart';
import 'package:diary_app/models/diary_model.dart';
import 'package:diary_app/database_access/diary_database.dart';
import 'package:diary_app/utils/constants.dart';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({
    super.key,
    required this.theme,
    required this.setTheme,
    required this.sharedPref,
  });

  final bool theme;
  final void Function(bool) setTheme;
  final SharedPreferences sharedPref;

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  List<Diary> diaryEntries = [];
  int bottomItem = 0;
  DateTime selectedDateCalendar = DateTime.now();

  void setSelectedDateCalendar(DateTime date) {
    setState(() {
      selectedDateCalendar = date;
    });
  }

  // Function to set diary entries. Possible modes are append, delete and update.
  // Then it will sort the diary entries by createdDate and write it to disk.
  void addDiaryEntry(Diary newDiary) {
    insertDiaryIntoDB(newDiary);
    setState(() {});
  }

  void updateDiaryEntry(Diary updatedEntry) {
    updateDiaryDB(updatedEntry);
    setState(() {});
  }

  void deleteDiaryEntry(Diary toDelete) {
    removeDiaryFromDB(toDelete.id);
    setState(() {});
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

  Future<bool> _confirmExit() async {
    return await showDialog<bool>(
          // return values info: DISCARD - true; CANCEL - false.
          // And it'll enable cancel by default
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: const Text("Are you want to exit the app?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // Used future builder in the list of diary entries future returned by the database
    // TODO: Override back button and back gesture to exit application
    return WillPopScope(
      onWillPop: _confirmExit,
      child: FutureBuilder<List<Diary>>(
        future: getDiariesFromDB(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(appTitle),
              actions: <Widget>[
                // TODO: Feature - Favorite diary entry
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
                // IconButton(onPressed: () {}, icon: const Icon(Icons.sell_outlined)),
                // TODO: Feature - Search diary entries
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
            drawer: DiaryDrawer(
              theme: widget.theme,
              setTheme: widget.setTheme,
              sharedPref: widget.sharedPref,
            ),
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
                setSelectedDateCalendar: setSelectedDateCalendar,
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
                      diaryEntry: Diary(createdDate: selectedDateCalendar),
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
      ),
    );
  }
}
