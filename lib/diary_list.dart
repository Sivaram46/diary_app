import 'package:flutter/material.dart';
import 'diary_model.dart';
import 'constants.dart';
import 'diary_page.dart';

class DiaryListEntry extends StatefulWidget {
  const DiaryListEntry({
    super.key,
    required this.diaryEntry,
    required this.updateDiaryEntry,
    required this.addDiaryEntry,
    required this.deleteDiaryEntry,
  });

  final Diary diaryEntry;
  final void Function(Diary) addDiaryEntry;
  final void Function(Diary) deleteDiaryEntry;
  final void Function(Diary, Diary) updateDiaryEntry;

  @override
  State<DiaryListEntry> createState() => _DiaryListEntryState();
}

class _DiaryListEntryState extends State<DiaryListEntry> {
  @override
  Widget build(BuildContext context) {
    String titleText = widget.diaryEntry.title ?? "";
    String? month = monthMap[widget.diaryEntry.createdDate.month];
    // TODO: Customize tile such that month under CircleAvatar and show title if present...
    return ListTile(
      title: Text(titleText.isNotEmpty ? titleText : "No title"),
      leading: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(widget.diaryEntry.createdDate.day.toString()),
          ),
          Text(month ?? ""),
        ],
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryPage(
              diaryEntry: widget.diaryEntry,
              addDiaryEntry: widget.addDiaryEntry,
              updateDiaryEntry: widget.updateDiaryEntry,
              deleteDiaryEntry: widget.deleteDiaryEntry,
              isEdit: false,
            ),
          ),
        );
      },
    );
  }
}


class DiaryList extends StatefulWidget {
  const DiaryList({
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
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return DiaryListEntry(
            diaryEntry: widget.diaryEntries[index],
            updateDiaryEntry: widget.updateDiaryEntry,
            addDiaryEntry: widget.addDiaryEntry,
            deleteDiaryEntry: widget.deleteDiaryEntry,
          );
        },

        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: widget.diaryEntries.length
    );
  }
}
