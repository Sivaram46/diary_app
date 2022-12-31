import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'diary_model.dart';
import 'diary_list.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({
    super.key,
    required this.diaryEntries,
    required this.updateDiaryEntry,
    required this.addDiaryEntry,
    required this.deleteDiaryEntry,
  });

  final List<Diary> diaryEntries;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary, Diary) updateDiaryEntry;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final ValueNotifier<List<Diary>> _selectedEntries;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEntries = ValueNotifier(_getEntriesForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEntries.dispose();
    super.dispose();
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // TODO: Group same day diary entries with values as index in diaryEntries
  List<Diary> _getEntriesForDay(DateTime day) {
    List<Diary> filterResults = [];
    for (final diary in widget.diaryEntries) {
      if (isSameDay(diary.createdDate, day)) {
        filterResults.add(diary);
      }
    }
    return filterResults;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEntries.value = _getEntriesForDay(selectedDay);
    }
  }

  // TODO: Pass the selected value in calendar when creating new diary entry
  // TODO: Bug - when diary entry is date changed, it still shows in old date
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar<Diary>(
            firstDay: DateTime(2001),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEntriesForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: true,
            ),
            onDaySelected: _onDaySelected,
            // onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Diary>>(
              valueListenable: _selectedEntries,
              builder: (context, value, _) {
                return
                  value.isNotEmpty
                  ? DiaryList(
                    diaryEntries: value,
                    updateDiaryEntry: widget.updateDiaryEntry,
                    addDiaryEntry: widget.addDiaryEntry,
                    deleteDiaryEntry: widget.deleteDiaryEntry,
                  ) :
                  const Text("No diary entries");
              },
            ),
          ),
        ],
      ),
    );
  }
}