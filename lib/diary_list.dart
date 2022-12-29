import 'package:flutter/material.dart';
import 'diary_model.dart';
import 'constants.dart';
import 'diary_view.dart';

class DiaryListEntry extends StatefulWidget {
  const DiaryListEntry({super.key, required this.diaryEntry, required this.setDiaryEntries});

  final Diary diaryEntry;
  final void Function(Diary, Mode, [int]) setDiaryEntries;

  @override
  State<DiaryListEntry> createState() => _DiaryListEntryState();
}

class _DiaryListEntryState extends State<DiaryListEntry> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.diaryEntry.title ?? "No title"),
      // TODO: Set body as ListTile.title when title is null
      // subtitle: Text(widget.diaryEntryToShow.body),
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(widget.diaryEntry.createdDate.day.toString()),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryView(
                diaryEntry: widget.diaryEntry,
                setDiaryEntries: widget.setDiaryEntries,
            ),
          ),
        );
      },
    );
  }
}


class DiaryList extends StatefulWidget {
  const DiaryList({super.key, required this.diaryEntries, required this.setDiaryEntries});

  final List<Diary> diaryEntries;
  final void Function(Diary, Mode, [int]) setDiaryEntries;

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
            setDiaryEntries: widget.setDiaryEntries,
          );
        },

        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: widget.diaryEntries.length
    );
  }
}
